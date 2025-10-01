import { NextFunction, Request, Response } from "express";

export function authMiddleware({req, res, next}: {req: Request, res: Response, next: NextFunction}) {
  

    next();
}
