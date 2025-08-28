from app import calc
from django.test import SimpleTestCase

class TestCalc(SimpleTestCase):
   
   def test_substract_numbers(self):
       result = calc.substract(15, 10)
       self.assertEqual(result, 5)


   def test_numbers(self):
     res = calc.add(5,6)

     self.assertEqual(res,11)
