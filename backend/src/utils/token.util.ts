import jwt, { SignOptions } from 'jsonwebtoken';
import { env } from '../config';
import { JwtPayload } from '../types';

export class TokenUtils {
  static generate(payload: JwtPayload): string {
    const options: SignOptions = {
      // @ts-expect-error - JWT library accepts string values like "1h", "7d" etc. despite stricter TypeScript typing
      expiresIn: env.JWT_EXPIRES_IN,
    };
    return jwt.sign(payload, env.JWT_SECRET, options);
  }

  static verify(token: string): JwtPayload {
    return jwt.verify(token, env.JWT_SECRET) as JwtPayload;
  }

  static decode(token: string): JwtPayload | null {
    return jwt.decode(token) as JwtPayload | null;
  }
}
