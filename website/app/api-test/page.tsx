'use client';

import { useState } from 'react';
import { adminApi, buyerApi, sellerApi, handleApiError } from '@/lib/api';
import { useSearchParams } from 'next/navigation';
import Link from 'next/link';

export default function ApiTestPage() {
  const searchParams = useSearchParams();
  const role = searchParams.get('role') || 'admin';

  const [loading, setLoading] = useState(false);
  const [response, setResponse] = useState<string>('');
  const [error, setError] = useState<string>('');

  const clearMessages = () => {
    setResponse('');
    setError('');
  };

  // Admin Test Functions
  const testAdminSignup = async () => {
    clearMessages();
    setLoading(true);
    try {
      const res = await adminApi.signup({
        name: 'Test Admin',
        email: `admin${Date.now()}@test.com`,
        password: 'password123',
        admin_key: process.env.NEXT_PUBLIC_ADMIN_KEY || 'test-key',
      });
      setResponse(JSON.stringify(res.data, null, 2));
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setLoading(false);
    }
  };

  const testAdminLogin = async () => {
    clearMessages();
    setLoading(true);
    try {
      const res = await adminApi.login({
        email: 'admin@test.com',
        password: 'password123',
      });
      setResponse(JSON.stringify(res.data, null, 2));
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setLoading(false);
    }
  };

  // Buyer Test Functions
  const testBuyerSignup = async () => {
    clearMessages();
    setLoading(true);
    try {
      const timestamp = Date.now();
      const res = await buyerApi.signup({
        organization_type: 'Corporation',
        organization_email: `buyer${timestamp}@test.com`,
        organization_name: `Test Buyer Corp ${timestamp}`,
        phone_no: '1234567890',
        password: 'password123',
      });
      setResponse(JSON.stringify(res.data, null, 2));
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setLoading(false);
    }
  };

  const testBuyerLogin = async () => {
    clearMessages();
    setLoading(true);
    try {
      const res = await buyerApi.login({
        email: 'buyer@test.com',
        password: 'password123',
      });
      setResponse(JSON.stringify(res.data, null, 2));
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setLoading(false);
    }
  };

  // Seller Test Functions
  const testSellerSignup = async () => {
    clearMessages();
    setLoading(true);
    try {
      const timestamp = Date.now();
      const res = await sellerApi.signup({
        organization_email: `seller${timestamp}@test.com`,
        organization_name: `Test Seller Inc ${timestamp}`,
        phone_no: '9876543210',
        password: 'password123',
      });
      setResponse(JSON.stringify(res.data, null, 2));
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setLoading(false);
    }
  };

  const testSellerLogin = async () => {
    clearMessages();
    setLoading(true);
    try {
      const res = await sellerApi.login({
        email: 'seller@test.com',
        password: 'password123',
      });
      setResponse(JSON.stringify(res.data, null, 2));
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setLoading(false);
    }
  };

  const renderTestButtons = () => {
    switch (role) {
      case 'admin':
        return (
          <>
            <button
              onClick={testAdminSignup}
              disabled={loading}
              className="rounded-md bg-blue-600 px-4 py-2 text-white hover:bg-blue-700 disabled:opacity-50"
            >
              Test Admin Signup
            </button>
            <button
              onClick={testAdminLogin}
              disabled={loading}
              className="rounded-md bg-blue-600 px-4 py-2 text-white hover:bg-blue-700 disabled:opacity-50"
            >
              Test Admin Login
            </button>
          </>
        );
      case 'buyer':
        return (
          <>
            <button
              onClick={testBuyerSignup}
              disabled={loading}
              className="rounded-md bg-green-600 px-4 py-2 text-white hover:bg-green-700 disabled:opacity-50"
            >
              Test Buyer Signup
            </button>
            <button
              onClick={testBuyerLogin}
              disabled={loading}
              className="rounded-md bg-green-600 px-4 py-2 text-white hover:bg-green-700 disabled:opacity-50"
            >
              Test Buyer Login
            </button>
          </>
        );
      case 'seller':
        return (
          <>
            <button
              onClick={testSellerSignup}
              disabled={loading}
              className="rounded-md bg-purple-600 px-4 py-2 text-white hover:bg-purple-700 disabled:opacity-50"
            >
              Test Seller Signup
            </button>
            <button
              onClick={testSellerLogin}
              disabled={loading}
              className="rounded-md bg-purple-600 px-4 py-2 text-white hover:bg-purple-700 disabled:opacity-50"
            >
              Test Seller Login
            </button>
          </>
        );
      default:
        return null;
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 p-8 dark:bg-gray-900">
      <div className="mx-auto max-w-4xl">
        <div className="mb-8">
          <Link
            href="/"
            className="text-sm text-blue-600 hover:underline dark:text-blue-400"
          >
            ← Back to Home
          </Link>
          <h1 className="mt-4 text-3xl font-bold text-gray-900 dark:text-white">
            API Testing - {role.charAt(0).toUpperCase() + role.slice(1)}
          </h1>
          <p className="mt-2 text-gray-600 dark:text-gray-400">
            Test backend API endpoints for the {role} role
          </p>
        </div>

        {/* Role Selector */}
        <div className="mb-6 flex gap-2">
          <a
            href="/api-test?role=admin"
            className={`rounded-md px-4 py-2 ${
              role === 'admin'
                ? 'bg-blue-600 text-white'
                : 'bg-gray-200 text-gray-700 dark:bg-gray-700 dark:text-gray-300'
            }`}
          >
            Admin
          </a>
          <a
            href="/api-test?role=buyer"
            className={`rounded-md px-4 py-2 ${
              role === 'buyer'
                ? 'bg-green-600 text-white'
                : 'bg-gray-200 text-gray-700 dark:bg-gray-700 dark:text-gray-300'
            }`}
          >
            Buyer
          </a>
          <a
            href="/api-test?role=seller"
            className={`rounded-md px-4 py-2 ${
              role === 'seller'
                ? 'bg-purple-600 text-white'
                : 'bg-gray-200 text-gray-700 dark:bg-gray-700 dark:text-gray-300'
            }`}
          >
            Seller
          </a>
        </div>

        {/* Test Buttons */}
        <div className="mb-6 flex flex-wrap gap-4">{renderTestButtons()}</div>

        {/* Loading State */}
        {loading && (
          <div className="rounded-lg border border-gray-200 bg-white p-4 dark:border-gray-700 dark:bg-gray-800">
            <p className="text-gray-600 dark:text-gray-400">Loading...</p>
          </div>
        )}

        {/* Success Response */}
        {response && (
          <div className="rounded-lg border border-green-200 bg-green-50 p-4 dark:border-green-900 dark:bg-green-950">
            <h3 className="mb-2 font-semibold text-green-900 dark:text-green-100">
              Success Response:
            </h3>
            <pre className="overflow-x-auto text-sm text-green-800 dark:text-green-200">
              {response}
            </pre>
          </div>
        )}

        {/* Error Response */}
        {error && (
          <div className="rounded-lg border border-red-200 bg-red-50 p-4 dark:border-red-900 dark:bg-red-950">
            <h3 className="mb-2 font-semibold text-red-900 dark:text-red-100">
              Error:
            </h3>
            <pre className="overflow-x-auto text-sm text-red-800 dark:text-red-200">
              {error}
            </pre>
          </div>
        )}

        {/* API Info */}
        <div className="mt-8 rounded-lg border border-gray-200 bg-white p-6 dark:border-gray-700 dark:bg-gray-800">
          <h3 className="mb-4 text-lg font-semibold text-gray-900 dark:text-white">
            Backend API Information
          </h3>
          <div className="space-y-2 text-sm text-gray-600 dark:text-gray-400">
            <p>
              <strong>Base URL:</strong>{' '}
              <code className="rounded bg-gray-100 px-2 py-1 dark:bg-gray-700">
                http://localhost:4000/api/v1
              </code>
            </p>
            <p>
              <strong>Current Role:</strong> {role}
            </p>
            <p>
              <strong>Available Endpoints:</strong>
            </p>
            <ul className="ml-4 list-inside list-disc">
              <li>POST /{role}/signup</li>
              <li>POST /{role}/login</li>
              {role !== 'admin' && (
                <>
                  <li>POST /{role}/send-otp</li>
                  <li>POST /{role}/verify-otp</li>
                </>
              )}
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}
