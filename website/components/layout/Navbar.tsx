'use client';

import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { useState, useEffect } from 'react';
import { adminApi, buyerApi, sellerApi, handleApiError } from '@/lib/api';
import NotificationBanner from './NotificationBanner';

interface NavbarProps {
  transparent?: boolean;
}

export default function Navbar({ transparent = false }: NavbarProps) {
  const pathname = usePathname();
  const router = useRouter();
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [userType, setUserType] = useState<'admin' | 'buyer' | 'seller' | null>(
    null
  );
  const [userName, setUserName] = useState<string>('');
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);

  // Check authentication status on mount
  useEffect(() => {
    const checkAuth = async () => {
      try {
        // Try to fetch profile based on current route
        if (pathname?.startsWith('/admin')) {
          const response = await adminApi.getProfile();
          setIsAuthenticated(true);
          setUserType('admin');
          setUserName(response.data.name || 'Admin');
        } else if (pathname?.startsWith('/buyer')) {
          const response = await buyerApi.getProfile();
          setIsAuthenticated(true);
          setUserType('buyer');
          setUserName(response.data.organization_name || 'Buyer');
        } else if (pathname?.startsWith('/seller')) {
          const response = await sellerApi.getProfile();
          setIsAuthenticated(true);
          setUserType('seller');
          setUserName(response.data.organization_name || 'Seller');
        } else {
          setIsAuthenticated(false);
          setUserType(null);
        }
      } catch {
        setIsAuthenticated(false);
        setUserType(null);
      }
    };

    checkAuth();
  }, [pathname]);

  const handleLogout = async () => {
    try {
      if (userType === 'admin') {
        await adminApi.logout();
      } else if (userType === 'buyer') {
        await buyerApi.logout();
      } else if (userType === 'seller') {
        await sellerApi.logout();
      }

      // Clear local state
      setIsAuthenticated(false);
      setUserType(null);
      setUserName('');
      setIsDropdownOpen(false);

      // Redirect to auth page
      router.push('/auth');
    } catch (error) {
      console.error('Logout error:', handleApiError(error));
      // Even if logout API fails, redirect to auth page
      router.push('/auth');
    }
  };

  const getDashboardLink = () => {
    if (userType === 'admin') return '/admin/dashboard';
    if (userType === 'buyer') return '/buyer/dashboard';
    if (userType === 'seller') return '/seller/dashboard';
    return '/';
  };

  const getProfileLink = () => {
    if (userType === 'admin') return '/admin/profile';
    if (userType === 'buyer') return '/buyer/profile';
    if (userType === 'seller') return '/seller/profile';
    return '/';
  };

  return (
    <>
      <header
        className={`${
          transparent
            ? 'bg-transparent absolute w-full z-50'
            : 'bg-white border-b border-gray-200'
        } shadow-sm transition-all duration-300`}
      >
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            {/* Logo */}
            <Link
              href="/"
              className="flex items-center space-x-3 hover:opacity-80 transition-opacity"
            >
              <div className="w-10 h-10 bg-linear-to-br from-green-700 to-green-500 rounded-lg flex items-center justify-center">
                <span className="text-white text-xl font-bold">🌱</span>
              </div>
              <div>
                <h1
                  className={`text-2xl font-bold ${transparent ? 'text-white' : 'text-gray-900'}`}
                >
                  ECO-Ex
                </h1>
                <p
                  className={`text-xs ${transparent ? 'text-gray-200' : 'text-gray-600'}`}
                >
                  Carbon Credit Marketplace
                </p>
              </div>
            </Link>

            {/* Desktop Navigation */}
            <nav className="hidden md:flex items-center space-x-6">
              <Link
                href="/#features"
                className={`${
                  transparent
                    ? 'text-white hover:text-green-200'
                    : 'text-gray-700 hover:text-green-700'
                } font-medium transition-colors`}
              >
                Features
              </Link>
              <Link
                href="/#how-it-works"
                className={`${
                  transparent
                    ? 'text-white hover:text-green-200'
                    : 'text-gray-700 hover:text-green-700'
                } font-medium transition-colors`}
              >
                How It Works
              </Link>
              <Link
                href="/#about"
                className={`${
                  transparent
                    ? 'text-white hover:text-green-200'
                    : 'text-gray-700 hover:text-green-700'
                } font-medium transition-colors`}
              >
                About
              </Link>

              {/* Auth Buttons / User Menu */}
              {isAuthenticated && userType ? (
                <div className="relative">
                  <button
                    onClick={() => setIsDropdownOpen(!isDropdownOpen)}
                    className={`flex items-center space-x-2 px-4 py-2 rounded-lg ${
                      transparent
                        ? 'bg-white/10 hover:bg-white/20 text-white backdrop-blur-sm'
                        : 'bg-gray-100 hover:bg-gray-200 text-gray-900'
                    } font-medium transition-all`}
                  >
                    <svg
                      className="w-5 h-5"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                      />
                    </svg>
                    <span>{userName}</span>
                    <svg
                      className={`w-4 h-4 transition-transform ${isDropdownOpen ? 'rotate-180' : ''}`}
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M19 9l-7 7-7-7"
                      />
                    </svg>
                  </button>

                  {/* Dropdown Menu */}
                  {isDropdownOpen && (
                    <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-2 border border-gray-200 z-50">
                      <Link
                        href={getDashboardLink()}
                        onClick={() => setIsDropdownOpen(false)}
                        className="block px-4 py-2 text-gray-700 hover:bg-gray-100 transition-colors"
                      >
                        <div className="flex items-center space-x-2">
                          <svg
                            className="w-4 h-4"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth={2}
                              d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"
                            />
                          </svg>
                          <span>Dashboard</span>
                        </div>
                      </Link>
                      <Link
                        href={getProfileLink()}
                        onClick={() => setIsDropdownOpen(false)}
                        className="block px-4 py-2 text-gray-700 hover:bg-gray-100 transition-colors"
                      >
                        <div className="flex items-center space-x-2">
                          <svg
                            className="w-4 h-4"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth={2}
                              d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                            />
                          </svg>
                          <span>Profile</span>
                        </div>
                      </Link>
                      <Link
                        href={`/${userType}/settings`}
                        onClick={() => setIsDropdownOpen(false)}
                        className="block px-4 py-2 text-gray-700 hover:bg-gray-100 transition-colors"
                      >
                        <div className="flex items-center space-x-2">
                          <svg
                            className="w-4 h-4"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth={2}
                              d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
                            />
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth={2}
                              d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                            />
                          </svg>
                          <span>Settings</span>
                        </div>
                      </Link>
                      {userType !== 'admin' && (
                        <Link
                          href={`/${userType}/wallet`}
                          onClick={() => setIsDropdownOpen(false)}
                          className="block px-4 py-2 text-gray-700 hover:bg-gray-100 transition-colors"
                        >
                          <div className="flex items-center space-x-2">
                            <svg
                              className="w-4 h-4"
                              fill="none"
                              stroke="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                strokeLinecap="round"
                                strokeLinejoin="round"
                                strokeWidth={2}
                                d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"
                              />
                            </svg>
                            <span>Wallet</span>
                          </div>
                        </Link>
                      )}
                      {userType === 'buyer' && (
                        <Link
                          href="/buyer/cart"
                          onClick={() => setIsDropdownOpen(false)}
                          className="block px-4 py-2 text-gray-700 hover:bg-gray-100 transition-colors"
                        >
                          <div className="flex items-center space-x-2">
                            <svg
                              className="w-4 h-4"
                              fill="none"
                              stroke="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                strokeLinecap="round"
                                strokeLinejoin="round"
                                strokeWidth={2}
                                d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"
                              />
                            </svg>
                            <span>Cart</span>
                          </div>
                        </Link>
                      )}
                      <hr className="my-2 border-gray-200" />
                      <button
                        onClick={handleLogout}
                        className="w-full text-left px-4 py-2 text-red-600 hover:bg-red-50 transition-colors"
                      >
                        <div className="flex items-center space-x-2">
                          <svg
                            className="w-4 h-4"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              strokeWidth={2}
                              d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"
                            />
                          </svg>
                          <span>Logout</span>
                        </div>
                      </button>
                    </div>
                  )}
                </div>
              ) : (
                <div className="flex items-center space-x-3">
                  <Link
                    href="/auth"
                    className={`px-5 py-2.5 rounded-lg font-semibold transition-all ${
                      transparent
                        ? 'bg-white text-green-700 hover:bg-gray-100'
                        : 'bg-linear-to-r from-green-700 to-green-600 text-white hover:from-green-800 hover:to-green-700 shadow-md hover:shadow-lg'
                    }`}
                  >
                    Get Started
                  </Link>
                </div>
              )}
            </nav>

            {/* Mobile Menu Button */}
            <button
              onClick={() => setIsMenuOpen(!isMenuOpen)}
              className="md:hidden p-2 rounded-lg hover:bg-gray-100 transition-colors"
            >
              <svg
                className={`w-6 h-6 ${transparent ? 'text-white' : 'text-gray-900'}`}
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                {isMenuOpen ? (
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M6 18L18 6M6 6l12 12"
                  />
                ) : (
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M4 6h16M4 12h16M4 18h16"
                  />
                )}
              </svg>
            </button>
          </div>

          {/* Mobile Menu */}
          {isMenuOpen && (
            <div className="md:hidden mt-4 pt-4 border-t border-gray-200">
              <nav className="flex flex-col space-y-3">
                <Link
                  href="/#features"
                  onClick={() => setIsMenuOpen(false)}
                  className={`${
                    transparent ? 'text-white' : 'text-gray-700'
                  } hover:text-green-700 font-medium transition-colors`}
                >
                  Features
                </Link>
                <Link
                  href="/#how-it-works"
                  onClick={() => setIsMenuOpen(false)}
                  className={`${
                    transparent ? 'text-white' : 'text-gray-700'
                  } hover:text-green-700 font-medium transition-colors`}
                >
                  How It Works
                </Link>
                <Link
                  href="/#about"
                  onClick={() => setIsMenuOpen(false)}
                  className={`${
                    transparent ? 'text-white' : 'text-gray-700'
                  } hover:text-green-700 font-medium transition-colors`}
                >
                  About
                </Link>

                {isAuthenticated && userType ? (
                  <>
                    <hr className="border-gray-300" />
                    <Link
                      href={getDashboardLink()}
                      onClick={() => setIsMenuOpen(false)}
                      className={`${
                        transparent ? 'text-white' : 'text-gray-700'
                      } hover:text-green-700 font-medium transition-colors`}
                    >
                      Dashboard
                    </Link>
                    <Link
                      href={getProfileLink()}
                      onClick={() => setIsMenuOpen(false)}
                      className={`${
                        transparent ? 'text-white' : 'text-gray-700'
                      } hover:text-green-700 font-medium transition-colors`}
                    >
                      Profile
                    </Link>
                    <Link
                      href={`/${userType}/settings`}
                      onClick={() => setIsMenuOpen(false)}
                      className={`${
                        transparent ? 'text-white' : 'text-gray-700'
                      } hover:text-green-700 font-medium transition-colors`}
                    >
                      Settings
                    </Link>
                    {userType !== 'admin' && (
                      <Link
                        href={`/${userType}/wallet`}
                        onClick={() => setIsMenuOpen(false)}
                        className={`${
                          transparent ? 'text-white' : 'text-gray-700'
                        } hover:text-green-700 font-medium transition-colors`}
                      >
                        Wallet
                      </Link>
                    )}
                    {userType === 'buyer' && (
                      <Link
                        href="/buyer/cart"
                        onClick={() => setIsMenuOpen(false)}
                        className={`${
                          transparent ? 'text-white' : 'text-gray-700'
                        } hover:text-green-700 font-medium transition-colors`}
                      >
                        Cart
                      </Link>
                    )}
                    <button
                      onClick={() => {
                        handleLogout();
                        setIsMenuOpen(false);
                      }}
                      className="text-left text-red-600 hover:text-red-700 font-medium transition-colors"
                    >
                      Logout
                    </button>
                  </>
                ) : (
                  <>
                    <hr className="border-gray-300" />
                    <Link
                      href="/auth"
                      onClick={() => setIsMenuOpen(false)}
                      className="px-5 py-2.5 bg-linear-to-r from-green-700 to-green-600 text-white rounded-lg font-semibold hover:from-green-800 hover:to-green-700 transition-all text-center"
                    >
                      Get Started
                    </Link>
                  </>
                )}
              </nav>
            </div>
          )}
        </div>
      </header>

      {/* Notification Banner */}
      {isAuthenticated && <NotificationBanner userType={userType} />}
    </>
  );
}
