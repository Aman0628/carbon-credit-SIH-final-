'use client';

import { useState, useEffect } from 'react';
import { buyerApi, handleApiError } from '@/lib/api';
import { useRouter } from 'next/navigation';

interface CartItem {
  id: string;
  quantity: number;
  project: {
    id: string;
    project_name: string;
    project_no: number;
    authority?: string;
    seller: {
      organization_name: string;
    };
  };
}

export default function CartPage() {
  const router = useRouter();
  const [cartItems, setCartItems] = useState<CartItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [updating, setUpdating] = useState<string | null>(null);

  const PRICE_PER_CREDIT = 100; // Placeholder price

  useEffect(() => {
    fetchCart();
  }, []);

  const fetchCart = async () => {
    try {
      setLoading(true);
      const response = await buyerApi.getCart();
      setCartItems(response.data.data.items);
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setLoading(false);
    }
  };

  const updateQuantity = async (cartItemId: string, newQuantity: number) => {
    try {
      setUpdating(cartItemId);
      await buyerApi.updateCartItem(cartItemId, { quantity: newQuantity });
      await fetchCart();
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setUpdating(null);
    }
  };

  const removeItem = async (cartItemId: string) => {
    if (!confirm('Remove this item from cart?')) return;

    try {
      await buyerApi.removeCartItem(cartItemId);
      await fetchCart();
    } catch (err) {
      setError(handleApiError(err));
    }
  };

  const clearCart = async () => {
    if (!confirm('Clear entire cart?')) return;

    try {
      await buyerApi.clearCart();
      await fetchCart();
    } catch (err) {
      setError(handleApiError(err));
    }
  };

  const getTotalCredits = () =>
    cartItems.reduce((sum, item) => sum + item.quantity, 0);
  const getTotalAmount = () => getTotalCredits() * PRICE_PER_CREDIT;

  const proceedToCheckout = () => {
    router.push('/buyer/checkout');
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-green-600"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <button
            onClick={() => router.push('/buyer/marketplace')}
            className="text-green-600 hover:text-green-700 mb-4"
          >
            ← Continue Shopping
          </button>
          <h1 className="text-3xl font-bold text-gray-900">Shopping Cart</h1>
          <p className="mt-2 text-gray-600">
            {cartItems.length} items in your cart
          </p>
        </div>

        {error && (
          <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-md">
            <p className="text-red-800">{error}</p>
          </div>
        )}

        {cartItems.length === 0 ? (
          <div className="bg-white rounded-lg shadow-md p-12 text-center">
            <svg
              className="mx-auto h-24 w-24 text-gray-400"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"
              />
            </svg>
            <h3 className="mt-4 text-xl font-medium text-gray-900">
              Your cart is empty
            </h3>
            <p className="mt-2 text-gray-600">
              Add some carbon credits to get started!
            </p>
            <button
              onClick={() => router.push('/buyer/marketplace')}
              className="mt-6 px-6 py-3 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors"
            >
              Browse Marketplace
            </button>
          </div>
        ) : (
          <div className="lg:grid lg:grid-cols-12 lg:gap-8">
            {/* Cart Items */}
            <div className="lg:col-span-8 space-y-4">
              {cartItems.map((item) => (
                <div
                  key={item.id}
                  className="bg-white rounded-lg shadow-md p-6"
                >
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <h3 className="text-lg font-semibold text-gray-900">
                        {item.project.project_name}
                      </h3>
                      <p className="text-sm text-gray-600 mt-1">
                        Project #{item.project.project_no} •{' '}
                        {item.project.seller.organization_name}
                      </p>
                      {item.project.authority && (
                        <p className="text-sm text-gray-500 mt-1">
                          Authority: {item.project.authority}
                        </p>
                      )}
                      <p className="text-lg font-semibold text-green-600 mt-3">
                        ${PRICE_PER_CREDIT} per credit
                      </p>
                    </div>

                    <button
                      onClick={() => removeItem(item.id)}
                      className="text-red-600 hover:text-red-700 ml-4"
                      title="Remove from cart"
                    >
                      <svg
                        className="h-6 w-6"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth={2}
                          d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                        />
                      </svg>
                    </button>
                  </div>

                  <div className="mt-4 flex items-center justify-between">
                    <div className="flex items-center space-x-3">
                      <label className="text-sm text-gray-700">Quantity:</label>
                      <div className="flex items-center border border-gray-300 rounded-md">
                        <button
                          onClick={() =>
                            updateQuantity(
                              item.id,
                              Math.max(1, item.quantity - 1)
                            )
                          }
                          disabled={updating === item.id || item.quantity <= 1}
                          className="px-3 py-1 hover:bg-gray-100 disabled:opacity-50"
                        >
                          −
                        </button>
                        <span className="px-4 py-1 border-x border-gray-300 min-w-[60px] text-center">
                          {item.quantity}
                        </span>
                        <button
                          onClick={() =>
                            updateQuantity(item.id, item.quantity + 1)
                          }
                          disabled={updating === item.id}
                          className="px-3 py-1 hover:bg-gray-100 disabled:opacity-50"
                        >
                          +
                        </button>
                      </div>
                      <span className="text-sm text-gray-600">credits</span>
                    </div>

                    <div className="text-right">
                      <p className="text-sm text-gray-600">Subtotal</p>
                      <p className="text-xl font-bold text-gray-900">
                        ${(item.quantity * PRICE_PER_CREDIT).toLocaleString()}
                      </p>
                    </div>
                  </div>
                </div>
              ))}

              <button
                onClick={clearCart}
                className="text-red-600 hover:text-red-700 text-sm font-medium"
              >
                Clear Cart
              </button>
            </div>

            {/* Order Summary */}
            <div className="lg:col-span-4 mt-8 lg:mt-0">
              <div className="bg-white rounded-lg shadow-md p-6 sticky top-4">
                <h2 className="text-xl font-bold text-gray-900 mb-4">
                  Order Summary
                </h2>

                <div className="space-y-3 mb-6">
                  <div className="flex justify-between text-gray-600">
                    <span>Total Credits:</span>
                    <span className="font-semibold">{getTotalCredits()}</span>
                  </div>
                  <div className="flex justify-between text-gray-600">
                    <span>Price per Credit:</span>
                    <span className="font-semibold">${PRICE_PER_CREDIT}</span>
                  </div>
                  <div className="border-t pt-3 flex justify-between text-lg font-bold text-gray-900">
                    <span>Total Amount:</span>
                    <span className="text-green-600">
                      ${getTotalAmount().toLocaleString()}
                    </span>
                  </div>
                </div>

                <button
                  onClick={proceedToCheckout}
                  className="w-full py-3 bg-green-600 text-white font-semibold rounded-md hover:bg-green-700 transition-colors"
                >
                  Proceed to Checkout
                </button>

                <button
                  onClick={() => router.push('/buyer/marketplace')}
                  className="w-full mt-3 py-3 border border-gray-300 text-gray-700 font-semibold rounded-md hover:bg-gray-50 transition-colors"
                >
                  Continue Shopping
                </button>

                <div className="mt-6 pt-6 border-t">
                  <h3 className="text-sm font-semibold text-gray-900 mb-2">
                    Need Help?
                  </h3>
                  <p className="text-sm text-gray-600">
                    Contact our support team if you have any questions about
                    your purchase.
                  </p>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
