from django.test import TestCase
from django.contrib.auth import get_user_model
from core.models import OrderItem, Item

User = get_user_model()


class OrderItemModelTestCase(TestCase):
    def setUp(self):
        # Create a user
        self.user = User.objects.create_user(
            username='testuser',
            email='testuser@example.com',
            password='secret'
        )

        # Create an item
        self.item = Item.objects.create(
            title='Test Item',
            price=10.0,
            discount_price=4.0,
            category='FD',
            label='P',
            slug='test-item',
            description='This is a test item',
        )

        # Create an OrderItem
        self.order_item = OrderItem.objects.create(
            user=self.user,
            item=self.item,
            quantity=5,
        )

    def test_order_item_total_item_price(self):
        total_item_price = self.order_item.get_total_item_price()
        self.assertEqual(total_item_price, 50.0)

    def test_order_item_total_discount_item_price(self):
        total_discount_item_price = self.order_item.get_total_discount_item_price()
        self.assertEqual(total_discount_item_price, 20.0)

    def test_order_item_amount_saved(self):
        amount_saved = self.order_item.get_amount_saved()
        self.assertEqual(amount_saved, 20.0)

    def test_order_item_final_price(self):
        final_price = self.order_item.get_final_price()
        self.assertEqual(final_price, 30.0)
