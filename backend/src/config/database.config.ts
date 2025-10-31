import { PrismaClient } from '@prisma/client';
import { isDevelopment } from './env.config';

declare global {
  var prisma: PrismaClient | undefined;
}

const prismaClientSingleton = () => {
  return new PrismaClient({
    log: isDevelopment ? ['query', 'error', 'warn'] : ['error'],
  });
};

export const db = globalThis.prisma ?? prismaClientSingleton();

if (isDevelopment) globalThis.prisma = db;

// Graceful shutdown
process.on('beforeExit', async () => {
  await db.$disconnect();
});
