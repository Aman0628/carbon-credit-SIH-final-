import { Response } from 'express';

export class ApiResponse {
  static success(
    res: Response,
    data: unknown,
    message: string = 'Success',
    statusCode: number = 200
  ) {
    return res.status(statusCode).json({
      success: true,
      message,
      data,
    });
  }

  static error(
    res: Response,
    message: string,
    statusCode: number = 500,
    errors?: Array<{ field: string; message: string }>
  ) {
    return res.status(statusCode).json({
      success: false,
      message,
      ...(errors ? { errors } : {}),
    });
  }

  static created(res: Response, data: unknown, message: string = 'Created') {
    return this.success(res, data, message, 201);
  }

  static badRequest(
    res: Response,
    message: string,
    errors?: Array<{ field: string; message: string }>
  ) {
    return this.error(res, message, 400, errors);
  }

  static unauthorized(res: Response, message: string = 'Unauthorized') {
    return this.error(res, message, 401);
  }

  static forbidden(res: Response, message: string = 'Forbidden') {
    return this.error(res, message, 403);
  }

  static notFound(res: Response, message: string = 'Resource not found') {
    return this.error(res, message, 404);
  }

  static conflict(res: Response, message: string = 'Resource already exists') {
    return this.error(res, message, 409);
  }

  static internalError(
    res: Response,
    message: string = 'Internal server error'
  ) {
    return this.error(res, message, 500);
  }
}
