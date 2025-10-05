// seller routes

export const sellerRouter = express.Router();
import express, { Request, Response } from 'express';
import { db } from '../db';
import bcrypt from 'bcryptjs';
import crypto from "crypto";
import jwt from "jsonwebtoken";
import { transporter } from '../services/mailer';


sellerRouter.post('/signup', async(req: Request, res: Response) => {
    const {organization_email, organization_name, phone_no, password} = req.body;
    const existingSeller = await db.seller.findUnique({
        where: {
            organization_email: organization_email
        }
    });
    if (existingSeller) {
        return res.status(409).send('Seller already exists');
    }
    const newSeller = await db.seller.create({
        data: {
            organization_email: organization_email,
            organization_name: organization_name,
            phone_no: phone_no,
            password: bcrypt.hashSync(password, 10), // Hash the password before storing
        }
    });
    res.send(`Seller Signed up with email: ${organization_email}`);
});

sellerRouter.post('/send-otp', async (req: Request, res: Response) => {
    const {email} = req.body;
    const otp = crypto.randomInt(100000, 999999).toString();
    const expiresAt = new Date(Date.now() + 5*60*1000); // 5min expiry

    await db.seller.update({
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

sellerRouter.post("/verify-otp", async (req, res) => {
  const { email, otp } = req.body;

  const seller = await db.seller.findUnique({
    where: { organization_email: email },
  });

  if (!seller || !seller.otp_code || !seller.otp_expires_at) {
    return res.status(400).json({ message: "OTP not found" });
  }

  if (seller.otp_code !== otp || seller.otp_expires_at < new Date()) {
    return res.status(400).json({ message: "Invalid or expired OTP" });
  }

  // verified
  await db.seller.update({
    where: { organization_email: email },
    data: {
      isVerified: true,
      otp_code: null,
      otp_expires_at: null,
    },
  });

  res.json({ message: "Email verified successfully" });
});

sellerRouter.post('/login', async (req, res) => {
  const { email, password } = req.body;
  const seller = await db.seller.findUnique({
    where: { organization_email: email }
  });

  if (!seller) {
    return res.status(404).json({ message: "Seller not found" });
  }

  bcrypt.compare(password, seller.password, (err, result) => {
    if (err || !result) {
      return res.status(401).json({ message: "Invalid password" });
    } else {
      // Generate JWT token
      const token = jwt.sign({ id: seller.id, email: seller.organization_email }, process.env.JWT_SECRET!, {
        expiresIn: "1h",
      });

      res.cookie("auth_token", token, {
      httpOnly: true,    // not accessible by JS
      secure: process.env.NODE_ENV === "production", // only https in prod
      sameSite: "strict",
      maxAge: 60 * 60 * 1000, // 1 hour
      });
      res.json({ message: "Logged in successfully" });
    }
})
})