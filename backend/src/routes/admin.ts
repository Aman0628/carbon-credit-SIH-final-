// admin routes
import { db } from '../db';
import bcrypt, { hash } from 'bcryptjs';

import express from 'express';
import { authMiddleware } from '../middleware/authMiddleware';
export const adminRouter = express.Router();
 

adminRouter.post('/signup', async (req, res) => {
    const {name, email, password, admin_key} = req.body;
    const existingAdmin = await db.admin.findUnique({
        where: {
            email: email
        }
    });
    if (existingAdmin) {
        return res.status(409).send('Admin already exists');
    }
    if (admin_key !== process.env.ADMIN_KEY) {
        return res.status(403).send('Invalid admin key');
    }
    const newAdmin = await db.admin.create({
        data: {
            name: name,
            email: email,
            password: bcrypt.hashSync(password, 10) // Hash the password before storing
        }
    });
    res.send(`Admin Signed up with email: ${email}`);
});

adminRouter.post('/login', async (req, res) => {
    const {email, password} = req.body;
    const admin = await db.admin.findUnique({
        where: {
            email: email,
        }
    });
    if(!admin) {
        return res.status(401).send('Unauthorized');
    }
    bcrypt.compare(password, admin?.password, (err, result) => {
        if (err || !result) {
            return res.status(401).send('Unauthorized');
        } else {
            
            res.send(`Admin Logged in with email: ${email}`);
        }
    });
});

adminRouter.use(authMiddleware);

adminRouter.get('/dashboard', (req, res) => {
    res.send('Admin Dashboard');
});
