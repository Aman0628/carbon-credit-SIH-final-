import Link from 'next/link';

export default function HomePage() {
  return (
    <div className="min-h-screen bg-linear-to-br from-green-50 via-emerald-50 to-teal-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-200 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-linear-to-br from-green-700 to-green-500 rounded-lg flex items-center justify-center">
                <span className="text-white text-xl font-bold">🌱</span>
              </div>
              <div>
                <h1 className="text-2xl font-bold text-gray-900">ECO-Ex</h1>
                <p className="text-xs text-gray-600">
                  Carbon Credit Marketplace
                </p>
              </div>
            </div>
            <nav className="hidden md:flex items-center space-x-6">
              <Link
                href="#features"
                className="text-gray-700 hover:text-green-700 font-medium"
              >
                Features
              </Link>
              <Link
                href="#how-it-works"
                className="text-gray-700 hover:text-green-700 font-medium"
              >
                How It Works
              </Link>
              <Link
                href="#about"
                className="text-gray-700 hover:text-green-700 font-medium"
              >
                About
              </Link>
            </nav>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto text-center">
          <div className="inline-flex items-center px-4 py-2 bg-green-100 border border-green-200 rounded-full text-green-800 text-sm font-semibold mb-6">
            <span className="w-2 h-2 bg-green-500 rounded-full mr-2 animate-pulse"></span>
            Verified Carbon Credit Platform
          </div>

          <h1 className="text-5xl md:text-7xl font-bold text-gray-900 mb-6 leading-tight">
            Balance Your
            <span className="bg-linear-to-r from-green-700 to-emerald-600 bg-clip-text text-transparent">
              {' '}
              Carbon Footprint
            </span>
          </h1>

          <p className="text-xl md:text-2xl text-gray-600 mb-12 max-w-3xl mx-auto leading-relaxed">
            Trade verified carbon credits, offset emissions, and contribute to a
            sustainable future on India's premier carbon marketplace.
          </p>

          {/* Role Selection Cards */}
          <div className="grid md:grid-cols-3 gap-8 max-w-5xl mx-auto mt-16">
            {/* Admin Card */}
            <div className="group relative bg-white rounded-2xl p-8 shadow-lg hover:shadow-2xl transition-all duration-300 border border-gray-100 hover:-translate-y-2">
              <div className="absolute -top-4 -right-4 w-24 h-24 bg-linear-to-br from-green-200 to-green-100 rounded-full blur-2xl opacity-50 group-hover:opacity-75 transition-opacity"></div>

              <div className="relative">
                <div className="w-16 h-16 bg-linear-to-br from-green-700 to-green-500 rounded-xl flex items-center justify-center mb-6 mx-auto">
                  <svg
                    className="w-8 h-8 text-white"
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
                </div>

                <h3 className="text-2xl font-bold text-gray-900 mb-3">Admin</h3>
                <p className="text-gray-600 mb-6">
                  Manage the platform, verify users, and oversee marketplace
                  operations.
                </p>

                <div className="space-y-2 mb-6">
                  <div className="flex items-center text-sm text-gray-600">
                    <svg
                      className="w-4 h-4 text-green-600 mr-2"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fillRule="evenodd"
                        d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                        clipRule="evenodd"
                      />
                    </svg>
                    User verification
                  </div>
                  <div className="flex items-center text-sm text-gray-600">
                    <svg
                      className="w-4 h-4 text-green-600 mr-2"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fillRule="evenodd"
                        d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                        clipRule="evenodd"
                      />
                    </svg>
                    Platform analytics
                  </div>
                  <div className="flex items-center text-sm text-gray-600">
                    <svg
                      className="w-4 h-4 text-green-600 mr-2"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fillRule="evenodd"
                        d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                        clipRule="evenodd"
                      />
                    </svg>
                    Transaction oversight
                  </div>
                </div>

                <div className="flex gap-3">
                  <Link
                    href="/admin/login"
                    className="flex-1 px-4 py-3 bg-linear-to-r from-green-700 to-green-600 text-white rounded-xl font-semibold hover:from-green-800 hover:to-green-700 transition-all shadow-md hover:shadow-lg text-center"
                  >
                    Login
                  </Link>
                  <Link
                    href="/admin/signup"
                    className="flex-1 px-4 py-3 border-2 border-green-700 text-green-700 rounded-xl font-semibold hover:bg-green-50 transition-all text-center"
                  >
                    Sign Up
                  </Link>
                </div>
              </div>
            </div>

            {/* Buyer Card */}
            <div className="group relative bg-white rounded-2xl p-8 shadow-lg hover:shadow-2xl transition-all duration-300 border border-gray-100 hover:-translate-y-2">
              <div className="absolute -top-4 -right-4 w-24 h-24 bg-linear-to-br from-blue-200 to-blue-100 rounded-full blur-2xl opacity-50 group-hover:opacity-75 transition-opacity"></div>

              <div className="relative">
                <div className="w-16 h-16 bg-linear-to-br from-blue-600 to-blue-400 rounded-xl flex items-center justify-center mb-6 mx-auto">
                  <svg
                    className="w-8 h-8 text-white"
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
                </div>

                <h3 className="text-2xl font-bold text-gray-900 mb-3">Buyer</h3>
                <p className="text-gray-600 mb-6">
                  Purchase verified carbon credits to offset your organization's
                  emissions.
                </p>

                <div className="space-y-2 mb-6">
                  <div className="flex items-center text-sm text-gray-600">
                    <svg
                      className="w-4 h-4 text-blue-600 mr-2"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fillRule="evenodd"
                        d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                        clipRule="evenodd"
                      />
                    </svg>
                    Browse marketplace
                  </div>
                  <div className="flex items-center text-sm text-gray-600">
                    <svg
                      className="w-4 h-4 text-blue-600 mr-2"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fillRule="evenodd"
                        d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                        clipRule="evenodd"
                      />
                    </svg>
                    Track portfolio
                  </div>
                  <div className="flex items-center text-sm text-gray-600">
                    <svg
                      className="w-4 h-4 text-blue-600 mr-2"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fillRule="evenodd"
                        d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                        clipRule="evenodd"
                      />
                    </svg>
                    Get certificates
                  </div>
                </div>

                <div className="flex gap-3">
                  <Link
                    href="/buyer/login"
                    className="flex-1 px-4 py-3 bg-linear-to-r from-blue-600 to-blue-500 text-white rounded-xl font-semibold hover:from-blue-700 hover:to-blue-600 transition-all shadow-md hover:shadow-lg text-center"
                  >
                    Login
                  </Link>
                  <Link
                    href="/buyer/signup"
                    className="flex-1 px-4 py-3 border-2 border-blue-600 text-blue-600 rounded-xl font-semibold hover:bg-blue-50 transition-all text-center"
                  >
                    Sign Up
                  </Link>
                </div>
              </div>
            </div>

            {/* Seller Card */}
            <div className="group relative bg-white rounded-2xl p-8 shadow-lg hover:shadow-2xl transition-all duration-300 border border-gray-100 hover:-translate-y-2">
              <div className="absolute -top-4 -right-4 w-24 h-24 bg-linear-to-br from-purple-200 to-purple-100 rounded-full blur-2xl opacity-50 group-hover:opacity-75 transition-opacity"></div>

              <div className="relative">
                <div className="w-16 h-16 bg-linear-to-br from-purple-600 to-purple-400 rounded-xl flex items-center justify-center mb-6 mx-auto">
                  <svg
                    className="w-8 h-8 text-white"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                    />
                  </svg>
                </div>

                <h3 className="text-2xl font-bold text-gray-900 mb-3">
                  Seller
                </h3>
                <p className="text-gray-600 mb-6">
                  List and sell verified carbon credits from your environmental
                  projects.
                </p>

                <div className="space-y-2 mb-6">
                  <div className="flex items-center text-sm text-gray-600">
                    <svg
                      className="w-4 h-4 text-purple-600 mr-2"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fillRule="evenodd"
                        d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                        clipRule="evenodd"
                      />
                    </svg>
                    List projects
                  </div>
                  <div className="flex items-center text-sm text-gray-600">
                    <svg
                      className="w-4 h-4 text-purple-600 mr-2"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fillRule="evenodd"
                        d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                        clipRule="evenodd"
                      />
                    </svg>
                    View analytics
                  </div>
                  <div className="flex items-center text-sm text-gray-600">
                    <svg
                      className="w-4 h-4 text-purple-600 mr-2"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fillRule="evenodd"
                        d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                        clipRule="evenodd"
                      />
                    </svg>
                    Earn revenue
                  </div>
                </div>

                <div className="flex gap-3">
                  <Link
                    href="/seller/login"
                    className="flex-1 px-4 py-3 bg-linear-to-r from-purple-600 to-purple-500 text-white rounded-xl font-semibold hover:from-purple-700 hover:to-purple-600 transition-all shadow-md hover:shadow-lg text-center"
                  >
                    Login
                  </Link>
                  <Link
                    href="/seller/signup"
                    className="flex-1 px-4 py-3 border-2 border-purple-600 text-purple-600 rounded-xl font-semibold hover:bg-purple-50 transition-all text-center"
                  >
                    Sign Up
                  </Link>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-20 px-4 sm:px-6 lg:px-8 bg-white">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-900 mb-4">
              Why Choose ECO-Ex?
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              India's most trusted carbon credit marketplace with verified
              projects and seamless trading.
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            <div className="p-6 rounded-2xl bg-linear-to-br from-green-50 to-emerald-50 border border-green-100">
              <div className="w-12 h-12 bg-green-600 rounded-xl flex items-center justify-center mb-4">
                <svg
                  className="w-6 h-6 text-white"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
                  />
                </svg>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">
                Verified Projects
              </h3>
              <p className="text-gray-600">
                All carbon credits from Gold Standard and VCS certified
                projects.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-linear-to-br from-blue-50 to-indigo-50 border border-blue-100">
              <div className="w-12 h-12 bg-blue-600 rounded-xl flex items-center justify-center mb-4">
                <svg
                  className="w-6 h-6 text-white"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M13 10V3L4 14h7v7l9-11h-7z"
                  />
                </svg>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">
                Instant Trading
              </h3>
              <p className="text-gray-600">
                Buy and sell carbon credits with real-time pricing and instant
                settlement.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-linear-to-br from-purple-50 to-pink-50 border border-purple-100">
              <div className="w-12 h-12 bg-purple-600 rounded-xl flex items-center justify-center mb-4">
                <svg
                  className="w-6 h-6 text-white"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                  />
                </svg>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">
                Market Analytics
              </h3>
              <p className="text-gray-600">
                Advanced tools for tracking portfolio performance and market
                trends.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto text-center">
          <div className="flex items-center justify-center space-x-3 mb-4">
            <div className="w-10 h-10 bg-linear-to-br from-green-500 to-green-400 rounded-lg flex items-center justify-center">
              <span className="text-white text-xl font-bold">🌱</span>
            </div>
            <h3 className="text-2xl font-bold">ECO-Ex</h3>
          </div>
          <p className="text-gray-400 mb-4">
            India's Premier Carbon Credit Marketplace
          </p>
          <p className="text-gray-500 text-sm">
            © 2024 ECO-Ex. All rights reserved.
          </p>
        </div>
      </footer>
    </div>
  );
}
