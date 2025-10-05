import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";

// auth using cookie

export function authMiddleware({req, res, next}: {req: Request, res: Response, next: NextFunction}) {
    const token = req.cookies?.auth_token;
    if (!token) {
        return res.status(401).json({ message: "Unauthorized" });
    }
    try {
        const jwtSecret = process.env.JWT_SECRET;
        if (!jwtSecret) {
            return res.status(500).json({ message: "JWT secret not configured" });
        }
        const decoded = jwt.verify(token, jwtSecret);
        (req as any).user = decoded;
        next();
    } catch (error) {
        res.status(401).json({ message: "Unauthorized" });
    }
}
