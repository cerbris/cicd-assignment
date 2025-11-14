"""
Simple Calculator Application for CI/CD Pipeline Demo
"""

class Calculator:
    """A simple calculator class for demonstration purposes."""

    def add(self, a, b):
        """Add two numbers."""
        return a + b

    def subtract(self, a, b):
        """Subtract b from a."""
        return a - b

    def multiply(self, a, b):
        """Multiply two numbers."""
        return a * b

    def divide(self, a, b):
        """Divide a by b."""
        if b == 0:
            raise ValueError("Cannot divide by zero")
        return a / b

    def power(self, base, exponent):
        """Calculate base raised to exponent."""
        return base ** exponent

    def modulo(self, a, b):
        """Calculate a modulo b."""
        if b == 0:
            raise ValueError("Cannot perform modulo with zero")
        return a % b


def main():
    """Main function to demonstrate calculator usage."""
    calc = Calculator()

    print("Calculator Demo")
    print("=" * 40)
    print(f"5 + 3 = {calc.add(5, 3)}")
    print(f"10 - 4 = {calc.subtract(10, 4)}")
    print(f"6 * 7 = {calc.multiply(6, 7)}")
    print(f"20 / 4 = {calc.divide(20, 4)}")
    print(f"2 ^ 8 = {calc.power(2, 8)}")
    print(f"17 % 5 = {calc.modulo(17, 5)}")
    print("=" * 40)


if __name__ == "__main__":
    main()