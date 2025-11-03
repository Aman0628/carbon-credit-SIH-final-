'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { Card } from '@/components/ui/Card';
import { Input } from '@/components/ui/Input';
import { Button } from '@/components/ui/Button';
import { Alert } from '@/components/ui/Alert';
import { adminApi, buyerApi, sellerApi, handleApiError } from '@/lib/api';

type UserRole = 'admin' | 'buyer' | 'seller';
type AuthMode = 'login' | 'signup';

export default function AuthPage() {
  const router = useRouter();
  const [authMode, setAuthMode] = useState<AuthMode>('login');
  const [selectedRole, setSelectedRole] = useState<UserRole>('buyer');
  const [isLoading, setIsLoading] = useState(false);
  const [checkingAuth, setCheckingAuth] = useState(true);
  const [alert, setAlert] = useState<{
    type: 'success' | 'error';
    message: string;
  } | null>(null);

  // Login form data
  const [loginData, setLoginData] = useState({
    email: '',
    password: '',
  });

  // Signup form data
  const [signupData, setSignupData] = useState({
    name: '',
    email: '',
    admin_key: '',
    organization_name: '',
    organization_email: '',
    organization_type: '',
    phone_no: '',
    password: '',
    confirmPassword: '',
  });

  const [errors, setErrors] = useState<Record<string, string>>({});

  // Check if user is already logged in
  useEffect(() => {
    const checkExistingAuth = async () => {
      try {
        // Try to get profile from each API to see if user is already logged in
        try {
          await adminApi.getProfile();
          router.push('/admin/dashboard');
          return;
        } catch {
          // Not an admin, try buyer
        }

        try {
          await buyerApi.getProfile();
          router.push('/buyer/dashboard');
          return;
        } catch {
          // Not a buyer, try seller
        }

        try {
          await sellerApi.getProfile();
          router.push('/seller/dashboard');
          return;
        } catch {
          // Not logged in as any role, show auth page
        }
      } finally {
        setCheckingAuth(false);
      }
    };

    checkExistingAuth();
  }, [router]);

  const handleLoginChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setLoginData((prev) => ({ ...prev, [name]: value }));
    if (errors[name]) {
      setErrors((prev) => ({ ...prev, [name]: '' }));
    }
  };

  const handleSignupChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>
  ) => {
    const { name, value } = e.target;
    setSignupData((prev) => ({ ...prev, [name]: value }));
    if (errors[name]) {
      setErrors((prev) => ({ ...prev, [name]: '' }));
    }
  };

  const validateLogin = () => {
    const newErrors: Record<string, string> = {};

    if (!loginData.email) {
      newErrors.email = 'Email is required';
    } else if (!/\S+@\S+\.\S+/.test(loginData.email)) {
      newErrors.email = 'Email is invalid';
    }

    if (!loginData.password) {
      newErrors.password = 'Password is required';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const validateSignup = () => {
    const newErrors: Record<string, string> = {};

    if (selectedRole === 'admin') {
      if (!signupData.name) newErrors.name = 'Name is required';
      if (!signupData.email) {
        newErrors.email = 'Email is required';
      } else if (!/\S+@\S+\.\S+/.test(signupData.email)) {
        newErrors.email = 'Email is invalid';
      }
      if (!signupData.admin_key) {
        newErrors.admin_key = 'Admin key is required';
      }
    }

    if (selectedRole === 'buyer') {
      if (!signupData.organization_type) {
        newErrors.organization_type = 'Organization type is required';
      }
      if (!signupData.organization_name) {
        newErrors.organization_name = 'Organization name is required';
      }
      if (!signupData.organization_email) {
        newErrors.organization_email = 'Organization email is required';
      } else if (!/\S+@\S+\.\S+/.test(signupData.organization_email)) {
        newErrors.organization_email = 'Email is invalid';
      }
      if (!signupData.phone_no) {
        newErrors.phone_no = 'Phone number is required';
      } else if (!/^\d{10}$/.test(signupData.phone_no)) {
        newErrors.phone_no = 'Phone number must be 10 digits';
      }
    }

    if (selectedRole === 'seller') {
      if (!signupData.organization_name) {
        newErrors.organization_name = 'Organization name is required';
      }
      if (!signupData.organization_email) {
        newErrors.organization_email = 'Organization email is required';
      } else if (!/\S+@\S+\.\S+/.test(signupData.organization_email)) {
        newErrors.organization_email = 'Email is invalid';
      }
      if (!signupData.phone_no) {
        newErrors.phone_no = 'Phone number is required';
      } else if (!/^\d{10}$/.test(signupData.phone_no)) {
        newErrors.phone_no = 'Phone number must be 10 digits';
      }
    }

    if (!signupData.password) {
      newErrors.password = 'Password is required';
    } else if (signupData.password.length < 8) {
      newErrors.password = 'Password must be at least 8 characters';
    }

    if (signupData.password !== signupData.confirmPassword) {
      newErrors.confirmPassword = 'Passwords do not match';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setAlert(null);

    if (!validateLogin()) return;

    setIsLoading(true);

    try {
      let response;
      let dashboardRoute = '';
      let loginSuccess = false;

      // Try admin login
      try {
        response = await adminApi.login(loginData);
        if (response?.data?.success) {
          dashboardRoute = '/admin/dashboard';
          loginSuccess = true;
        }
      } catch {
        // Try buyer
        try {
          response = await buyerApi.login(loginData);
          if (response?.data?.success) {
            dashboardRoute = '/buyer/dashboard';
            loginSuccess = true;
          }
        } catch {
          // Try seller
          try {
            response = await sellerApi.login(loginData);
            if (response?.data?.success) {
              dashboardRoute = '/seller/dashboard';
              loginSuccess = true;
            }
          } catch (error) {
            throw error;
          }
        }
      }

      if (loginSuccess && dashboardRoute) {
        setAlert({
          type: 'success',
          message: 'Login successful! Redirecting to your dashboard...',
        });

        setTimeout(() => {
          router.push(dashboardRoute);
          router.refresh();
        }, 1000);
      }
    } catch (error) {
      setAlert({
        type: 'error',
        message: handleApiError(error),
      });
    } finally {
      setIsLoading(false);
    }
  };

  const handleSignup = async (e: React.FormEvent) => {
    e.preventDefault();
    setAlert(null);

    if (!validateSignup()) return;

    setIsLoading(true);

    try {
      let response;

      if (selectedRole === 'admin') {
        response = await adminApi.signup({
          name: signupData.name,
          email: signupData.email,
          password: signupData.password,
          admin_key: signupData.admin_key,
        });
      } else if (selectedRole === 'buyer') {
        response = await buyerApi.signup({
          organization_type: signupData.organization_type,
          organization_name: signupData.organization_name,
          organization_email: signupData.organization_email,
          phone_no: signupData.phone_no,
          password: signupData.password,
        });
      } else if (selectedRole === 'seller') {
        response = await sellerApi.signup({
          organization_name: signupData.organization_name,
          organization_email: signupData.organization_email,
          phone_no: signupData.phone_no,
          password: signupData.password,
        });
      }

      if (response && response.data.success) {
        setAlert({
          type: 'success',
          message: 'Account created successfully! Redirecting to login...',
        });

        // Reset form
        setSignupData({
          name: '',
          email: '',
          admin_key: '',
          organization_name: '',
          organization_email: '',
          organization_type: '',
          phone_no: '',
          password: '',
          confirmPassword: '',
        });

        // Switch to login after 2 seconds
        setTimeout(() => {
          setAuthMode('login');
          setAlert(null);
        }, 2000);
      }
    } catch (error) {
      setAlert({
        type: 'error',
        message: handleApiError(error),
      });
    } finally {
      setIsLoading(false);
    }
  };

  const switchToSignup = () => {
    setAuthMode('signup');
    setAlert(null);
    setErrors({});
  };

  const switchToLogin = () => {
    setAuthMode('login');
    setAlert(null);
    setErrors({});
  };

  // Show loading state while checking if user is already authenticated
  if (checkingAuth) {
    return (
      <div className="min-h-screen bg-linear-to-br from-green-50 via-emerald-50 to-teal-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-green-600 border-t-transparent rounded-full animate-spin mx-auto"></div>
          <p className="mt-4 text-gray-600">Checking authentication...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-linear-to-br from-green-50 via-emerald-50 to-teal-50 flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        <Card>
          {/* Header */}
          <div className="text-center mb-6">
            <Link href="/" className="inline-block mb-4">
              <div className="flex items-center justify-center space-x-2">
                <div className="w-12 h-12 bg-linear-to-br from-green-700 to-green-500 rounded-xl flex items-center justify-center">
                  <span className="text-white text-2xl font-bold">🌱</span>
                </div>
                <span className="text-2xl font-bold text-gray-900">ECO-Ex</span>
              </div>
            </Link>
            <h1 className="text-3xl font-bold text-gray-900 mb-2">
              {authMode === 'login' ? 'Welcome Back' : 'Create Account'}
            </h1>
            <p className="text-gray-600">
              {authMode === 'login'
                ? 'Sign in to your account'
                : 'Join the carbon credit marketplace'}
            </p>
          </div>

          {alert && (
            <Alert
              type={alert.type}
              message={alert.message}
              onClose={() => setAlert(null)}
            />
          )}

          {/* Login Form */}
          {authMode === 'login' && (
            <form onSubmit={handleLogin} className="space-y-4">
              <Input
                type="email"
                name="email"
                label="Email Address"
                placeholder="your@email.com"
                value={loginData.email}
                onChange={handleLoginChange}
                error={errors.email}
                required
              />

              <Input
                type="password"
                name="password"
                label="Password"
                placeholder="Enter your password"
                value={loginData.password}
                onChange={handleLoginChange}
                error={errors.password}
                required
              />

              <Button type="submit" isLoading={isLoading} className="w-full">
                Sign In
              </Button>

              <div className="text-center mt-4">
                <p className="text-sm text-gray-600">
                  Don&apos;t have an account?{' '}
                  <button
                    type="button"
                    onClick={switchToSignup}
                    className="text-green-600 hover:text-green-700 font-medium"
                  >
                    Sign up
                  </button>
                </p>
              </div>
            </form>
          )}

          {/* Signup Form */}
          {authMode === 'signup' && (
            <form onSubmit={handleSignup} className="space-y-4">
              {/* Role Selection */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-3">
                  Select Your Role
                </label>
                <div className="grid grid-cols-3 gap-2">
                  <button
                    type="button"
                    onClick={() => setSelectedRole('admin')}
                    className={`px-4 py-3 rounded-lg border-2 transition-all text-sm font-medium ${
                      selectedRole === 'admin'
                        ? 'border-green-600 bg-green-50 text-green-700'
                        : 'border-gray-200 text-gray-700 hover:border-gray-300'
                    }`}
                  >
                    Admin
                  </button>
                  <button
                    type="button"
                    onClick={() => setSelectedRole('buyer')}
                    className={`px-4 py-3 rounded-lg border-2 transition-all text-sm font-medium ${
                      selectedRole === 'buyer'
                        ? 'border-blue-600 bg-blue-50 text-blue-700'
                        : 'border-gray-200 text-gray-700 hover:border-gray-300'
                    }`}
                  >
                    Buyer
                  </button>
                  <button
                    type="button"
                    onClick={() => setSelectedRole('seller')}
                    className={`px-4 py-3 rounded-lg border-2 transition-all text-sm font-medium ${
                      selectedRole === 'seller'
                        ? 'border-purple-600 bg-purple-50 text-purple-700'
                        : 'border-gray-200 text-gray-700 hover:border-gray-300'
                    }`}
                  >
                    Seller
                  </button>
                </div>
              </div>

              {/* Admin Fields */}
              {selectedRole === 'admin' && (
                <>
                  <Input
                    type="text"
                    name="name"
                    label="Full Name"
                    placeholder="John Doe"
                    value={signupData.name}
                    onChange={handleSignupChange}
                    error={errors.name}
                    required
                  />
                  <Input
                    type="email"
                    name="email"
                    label="Email Address"
                    placeholder="admin@ecoex.com"
                    value={signupData.email}
                    onChange={handleSignupChange}
                    error={errors.email}
                    required
                  />
                  <Input
                    type="password"
                    name="admin_key"
                    label="Admin Authorization Key"
                    placeholder="Enter admin key"
                    value={signupData.admin_key}
                    onChange={handleSignupChange}
                    error={errors.admin_key}
                    required
                  />
                </>
              )}

              {/* Buyer Fields */}
              {selectedRole === 'buyer' && (
                <>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Organization Type
                    </label>
                    <select
                      name="organization_type"
                      value={signupData.organization_type}
                      onChange={handleSignupChange}
                      className={`w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all ${
                        errors.organization_type
                          ? 'border-red-500'
                          : 'border-gray-300'
                      }`}
                      required
                    >
                      <option value="">Select type</option>
                      <option value="Corporate">Corporate</option>
                      <option value="Government">Government</option>
                      <option value="NGO">NGO</option>
                      <option value="Individual">Individual</option>
                    </select>
                    {errors.organization_type && (
                      <p className="mt-1 text-sm text-red-600">
                        {errors.organization_type}
                      </p>
                    )}
                  </div>
                  <Input
                    type="text"
                    name="organization_name"
                    label="Organization Name"
                    placeholder="Acme Corporation"
                    value={signupData.organization_name}
                    onChange={handleSignupChange}
                    error={errors.organization_name}
                    required
                  />
                  <Input
                    type="email"
                    name="organization_email"
                    label="Organization Email"
                    placeholder="contact@acme.com"
                    value={signupData.organization_email}
                    onChange={handleSignupChange}
                    error={errors.organization_email}
                    required
                  />
                  <Input
                    type="tel"
                    name="phone_no"
                    label="Phone Number"
                    placeholder="1234567890"
                    value={signupData.phone_no}
                    onChange={handleSignupChange}
                    error={errors.phone_no}
                    required
                  />
                </>
              )}

              {/* Seller Fields */}
              {selectedRole === 'seller' && (
                <>
                  <Input
                    type="text"
                    name="organization_name"
                    label="Organization Name"
                    placeholder="Green Energy Co."
                    value={signupData.organization_name}
                    onChange={handleSignupChange}
                    error={errors.organization_name}
                    required
                  />
                  <Input
                    type="email"
                    name="organization_email"
                    label="Organization Email"
                    placeholder="contact@greenenergy.com"
                    value={signupData.organization_email}
                    onChange={handleSignupChange}
                    error={errors.organization_email}
                    required
                  />
                  <Input
                    type="tel"
                    name="phone_no"
                    label="Phone Number"
                    placeholder="1234567890"
                    value={signupData.phone_no}
                    onChange={handleSignupChange}
                    error={errors.phone_no}
                    required
                  />
                </>
              )}

              {/* Common Password Fields */}
              <Input
                type="password"
                name="password"
                label="Password"
                placeholder="At least 8 characters"
                value={signupData.password}
                onChange={handleSignupChange}
                error={errors.password}
                required
              />
              <Input
                type="password"
                name="confirmPassword"
                label="Confirm Password"
                placeholder="Re-enter your password"
                value={signupData.confirmPassword}
                onChange={handleSignupChange}
                error={errors.confirmPassword}
                required
              />

              <Button type="submit" isLoading={isLoading} className="w-full">
                Create Account
              </Button>

              <div className="text-center mt-4">
                <p className="text-sm text-gray-600">
                  Already have an account?{' '}
                  <button
                    type="button"
                    onClick={switchToLogin}
                    className="text-green-600 hover:text-green-700 font-medium"
                  >
                    Sign in
                  </button>
                </p>
              </div>
            </form>
          )}

          <div className="mt-6 text-center">
            <Link
              href="/"
              className="text-sm text-gray-600 hover:text-gray-900 font-medium"
            >
              ← Back to home
            </Link>
          </div>
        </Card>
      </div>
    </div>
  );
}
