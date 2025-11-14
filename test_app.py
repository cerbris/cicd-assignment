"""
Unit tests for the Calculator application
"""

import unittest
from app import Calculator


class TestCalculator(unittest.TestCase):
    """Test cases for the Calculator class."""

    def setUp(self):
        """Set up test fixtures."""
        self.calc = Calculator()

    def test_add(self):
        """Test addition operation."""
        self.assertEqual(self.calc.add(5, 3), 8)
        self.assertEqual(self.calc.add(-1, 1), 0)
        self.assertEqual(self.calc.add(-5, -3), -8)
        self.assertEqual(self.calc.add(0, 0), 0)

    def test_subtract(self):
        """Test subtraction operation."""
        self.assertEqual(self.calc.subtract(10, 4), 6)
        self.assertEqual(self.calc.subtract(5, 10), -5)
        self.assertEqual(self.calc.subtract(-3, -7), 4)
        self.assertEqual(self.calc.subtract(0, 5), -5)

    def test_multiply(self):
        """Test multiplication operation."""
        self.assertEqual(self.calc.multiply(6, 7), 42)
        self.assertEqual(self.calc.multiply(-3, 4), -12)
        self.assertEqual(self.calc.multiply(-2, -5), 10)
        self.assertEqual(self.calc.multiply(5, 0), 0)

    def test_divide(self):
        """Test division operation."""
        self.assertEqual(self.calc.divide(20, 4), 5)
        self.assertEqual(self.calc.divide(15, 3), 5)
        self.assertEqual(self.calc.divide(-10, 2), -5)
        self.assertAlmostEqual(self.calc.divide(7, 2), 3.5)

    def test_divide_by_zero(self):
        """Test division by zero raises ValueError."""
        with self.assertRaises(ValueError):
            self.calc.divide(10, 0)

    def test_power(self):
        """Test power operation."""
        self.assertEqual(self.calc.power(2, 8), 256)
        self.assertEqual(self.calc.power(5, 2), 25)
        self.assertEqual(self.calc.power(10, 0), 1)
        self.assertEqual(self.calc.power(2, -1), 0.5)

    def test_modulo(self):
        """Test modulo operation."""
        self.assertEqual(self.calc.modulo(17, 5), 2)
        self.assertEqual(self.calc.modulo(20, 4), 0)
        self.assertEqual(self.calc.modulo(7, 3), 1)

    def test_modulo_by_zero(self):
        """Test modulo by zero raises ValueError."""
        with self.assertRaises(ValueError):
            self.calc.modulo(10, 0)


if __name__ == '__main__':
    unittest.main()