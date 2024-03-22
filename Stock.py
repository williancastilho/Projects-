class Product:
    def __init__(self, name, price, stock):
        self.aName = name
        self.aPrice = price
        self.aStock = stock

    def get_name(self):
        return self.aName

    def set_name(self, name):
        self.aName = name

    def get_price(self):
        return self.aPrice

    def set_price(self, price):
        self.aPrice = price

    def get_stock(self):
        return self.aStock

    def set_stock(self, stock):
        self.aStock = stock


class Stock:
    def __init__(self):
        self.aProductList = []

    def get_sort_list(self, sort_list, sort_key, ascending):
        if sort_key == "name":
            sort_list.sort(key=lambda x: x.get_name(), reverse=not ascending)
        elif sort_key == "price":
            sort_list.sort(key=lambda x: x.get_price(), reverse=not ascending)
        elif sort_key == "stock":
            sort_list.sort(key=lambda x: x.get_stock(), reverse=not ascending)
        else:
            print("sort key option invalid")

        print("sort_key =", sort_key, "- ascending =", ascending)
        for product in sort_list:
            print(f"name: {product.get_name()}, price: {product.get_price()}, stock: {product.get_stock()}")
        print("")

if __name__ == "__main__":
    xProductA = Product("Product A", 100, 5)
    xProductB = Product("Product B", 200, 3)
    xProductC = Product("Product C", 50, 10)

    xStock = Stock()
    xStock.aProductList.extend([xProductA, xProductB, xProductC])

    xStock.get_sort_list(xStock.aProductList, "name", False)
    xStock.get_sort_list(xStock.aProductList, "name", True)

    xStock.get_sort_list(xStock.aProductList, "price", False)
    xStock.get_sort_list(xStock.aProductList, "price", True)

    xStock.get_sort_list(xStock.aProductList, "stock", False)
    xStock.get_sort_list(xStock.aProductList, "stock", True)
