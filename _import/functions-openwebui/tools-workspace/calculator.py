# https://openwebui.com/t/makelvin/enhanced_calculator_

import sympy as sp


class Tools:
    def __init__(self):
        self.citation = True
        pass

    def calculator(self, equation: str) -> str:
        """
        Calculate the numeric result of an equation safely. All trigonometric functions are evaluated in radians.
        :param equation: The equation to calculate.
        :return: The result of the equation.
        """
        try:
            # Parse the equation using sympy
            equation = equation.lower()
            newequation = equation.replace("radians", "(pi/180)*")
            expr = sp.sympify(newequation)
            result = expr.evalf()
            return f"{equation} = {result}"
        except (sp.SympifyError, ValueError) as e:
            print(e)
            return "Invalid equation"


# Example usage
tools = Tools()
result = tools.calculator("3 + 5 * (2 - 8)")
print(result)  # Output: 3 + 5 * (2 - 8) = -25.0000000000000
