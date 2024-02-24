using System;
using System.IO;
using System.Collections.Generic;




namespace StockProgram {
    public class Product
    {
        private string aName;
        private float aPrice;
        private int aStock;
        
        public Product(string Name, float Price, int Stock){
            this.aName=Name;
            this.aPrice=Price;
            this.aStock=Stock;
        }

        public string getName(){
            return this.aName;
        }

        public void setName(string name){
           this.aName = name;
        }

       public float getPrice(){
            return this.aPrice;
       }

       public void setPrice(float price){
            this.aPrice = price;
       }

       public int getStock(){
            return this.aStock;
       }

       public void setStock(int stock){
            this.aStock = stock;
       }
 
    }
    
    public class Stock
    {

        private List<Product> aProductList = new List<Product>();



        public void getSortList(List<Product> list, string sort_key, bool ascending){
            if (sort_key == "name") {
                if (ascending) {
                    list.Sort((product1, product2) => product1.getName().CompareTo(product2.getName()));
                } else {
                    list.Sort((product1, product2) => product2.getName().CompareTo(product1.getName()));
                }

            } else if (sort_key == "price") {
                if (ascending) {
                    list.Sort((product1, product2) => product1.getPrice().CompareTo(product2.getPrice()));
                } else {
                    list.Sort((product1, product2) => product2.getPrice().CompareTo(product1.getPrice()));
                }

            } else if (sort_key == "stock") { 
                if (ascending) {
                    list.Sort((product1, product2) => product1.getStock().CompareTo(product2.getStock()));
                } else {
                    list.Sort((product1, product2) => product2.getStock().CompareTo(product1.getStock()));
                }
            } else {
                Console.WriteLine("sort key option invalid");
            }

            Console.WriteLine("sort_key = " + sort_key + " - ascending = " + ascending);
            foreach (var product in list)
            {      
                Console.WriteLine("name: " + product.getName() + ", price: " + product.getPrice() + ", stock: " + product.getStock());
            }
            Console.WriteLine("");
        }


        public static void Main(string[] args)
        {
            Product xProductA= new Product("Product A", 100, 5);
            Product xProductB= new Product("Product B", 200, 3);
            Product xProductC= new Product("Product C", 50, 10);

            Stock xStock = new Stock();
            xStock.aProductList.Add(xProductA); //1
            xStock.aProductList.Add(xProductB); //2
            xStock.aProductList.Add(xProductC); //3

            xStock.getSortList(xStock.aProductList, "name", false);
            xStock.getSortList(xStock.aProductList, "name", true);

            xStock.getSortList(xStock.aProductList, "price", false);
            xStock.getSortList(xStock.aProductList, "price", true);

            xStock.getSortList(xStock.aProductList, "stock", false);
            xStock.getSortList(xStock.aProductList, "stock", true);



        }
    }
}