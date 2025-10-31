import bcrypt from 'bcryptjs';

const SALT_ROUNDS = 10;

export class PasswordUtils {
  static async hash(password: string): Promise<string> {
    return bcrypt.hash(password, SALT_ROUNDS);
  }

  static async compare(
    password: string,
    hashedPassword: string
  ): Promise<boolean> {
    return bcrypt.compare(password, hashedPassword);
  }

  static hashSync(password: string): string {
    return bcrypt.hashSync(password, SALT_ROUNDS);
  }
}
