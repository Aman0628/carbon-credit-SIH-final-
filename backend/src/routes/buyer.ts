// buyer routes

import express, { Request, Response } from 'express';
import { transporter } from '../services/mailer';
import { db } from '../db';
import bcrypt from 'bcryptjs';
import crypto from "crypto"
export const buyerRouter = express.Router();

buyerRouter.post('/signup', async(req: Request, res: Response) => {
    const {organization_type,organization_email, organization_name, phone_no, password} = req.body;
    const existingBuyer = await db.buyer.findUnique({
        where: {
            organization_email: organization_email
        }
    });
    if (existingBuyer) {
        return res.status(409).send('Buyer already exists');
    }
    const newBuyer = await db.buyer.create({
        data: {
            organization_type: organization_type,
            organization_email: organization_email,
            organization_name: organization_name,
            phone_no: phone_no,
            password: bcrypt.hashSync(password, 10), // Hash the password before storing
        }
    });
    res.send(`Buyer Signed up with email: ${organization_email}`);
});

buyerRouter.post('/send-otp', async (req: Request, res: Response) => {
    const {email} = req.body;
    const otp = crypto.randomInt(100000, 999999).toString();
    const expiresAt = new Date(Date.now() + 5*60*1000); // 5min expiry

    await db.buyer.update({
        where: {
            organization_email: email
        },
        data: {
            otp_code: otp
        }
    });

    const sendOtp = await transporter.sendMail({
        from: process.env.EMAIL_USER,
        to: email,
        subject: "Your OTP Code",
        text: `Your OTP for signup is ${otp}. It expires in 5 minutes.`,
  });
  if(!sendOtp){
    return res.status(500).json({
        message: "Otp sending fails..."
    })
   }
    res.send("Otp sent successfully...");
})

buyerRouter.post("/verify-otp", async (req, res) => {
  const { email, otp } = req.body;

  const buyer = await db.buyer.findUnique({
    where: { organization_email: email },
  });

  if (!buyer || !buyer.otp_code || !buyer.otp_expires_at) {
    return res.status(400).json({ message: "OTP not found" });
  }

  if (buyer.otp_code !== otp || buyer.otp_expires_at < new Date()) {
    return res.status(400).json({ message: "Invalid or expired OTP" });
  }

  // verified
  await db.buyer.update({
    where: { organization_email: email },
    data: {
      isVerified: true,
      otp_code: null,
      otp_expires_at: null,
    },
  });

  res.json({ message: "Email verified successfully" });
});
buyerRouter.post('/login', async (req, res) => {
  const { email, password } = req.body;
  const buyer = await db.buyer.findUnique({
    where: { organization_email: email },
    select: { password: true },
  });

  if (!buyer) {
    return res.status(404).json({ message: "Buyer not found" });
  }

  bcrypt.compare(password, buyer.password, (err, result) => {
    if (err || !result) {
      return res.status(401).json({ message: "Invalid password" });
    } else {
    res.json({ message: "Logged in successfully" });
    }
})
})
