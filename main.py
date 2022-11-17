from menu import Menu
import getpass
import datetime
import random

import mysql.connector

# db connection
con = mysql.connector.connect(host="localhost", user="root",password="", database="sales management system")
cursor = con.cursor()

# ID of user
sessionID = 1

#2D list of [product_id, product_name, product_quantity, unit_price]
sessionCart = []

def addNewSupplier():
    print("Enter the following info: ")
    sup_id = input("ID: ")
    sup_name = input("Company Name: ")
    con_name = input("Contact Name: ")
    con_title = input("Contact_title: ")
    city = input("City: ")
    country = input("Country: ")
    phone = input("Phone: ")
    email = input("Email: ")

    query = f'''INSERT INTO `supplier`(`Id`, `SupplierName`, `ContactName`, `ContactTitle`, `City`, `Country`, `Phone`, `EmailId`) VALUES
                 ('{sup_id}','{sup_name}','{con_name}','{con_title}','{city}','{country}','{phone}','{email}');'''

    cursor.execute(query)
    con.commit()

def addNewProduct():
    print("Enter the following info: ")
    pr_id = input("ID: ")
    name = input("Name: ")
    supplier_id = input("Supplier ID: ")
    price = input("Unit Price: ")
    package = input("Package: ")

    query = f'''INSERT INTO Product (Id,ProductName,SupplierId,UnitPrice,Package,IsDiscontinued)VALUES 
                ({pr_id},'{name}',{supplier_id},{price},'{package}',0);'''

    cursor.execute(query)
    con.commit()

def today_sales():
    query = f'''
    SELECT SUM(TotalAmount) FROM orders
    WHERE OrderDate = '{str(datetime.datetime.today()).split(" ")[0]}'
    '''

    cursor.execute(query)
    try:    
        sales = float(cursor.fetchall()[0][0])
    except:
        return 0

    return sales

def total_sales():
    query = '''
    SELECT SUM(TotalAmount) FROM orders
    '''

    cursor.execute(query)
    try:
        total_sales = float(cursor.fetchall()[0][0])
    except:
        return 0

    return total_sales
    
def veiwCart():
    cart = Menu(title="Products - Select product to remove")
    def refreshCart():
        cart.set_options([])
        for product in sessionCart:
            product_id = product[0]
            product_name = product[1]
            product_quantitity = product[2]
        
            cart.add_option(f"{product_name} x {product_quantitity}", removeProductCart, {"product_id": product_id})
        cart.add_option("Checkout", checkout, {})
        cart.add_option("Exit", Menu.CLOSE, {})
    
    cart.set_refresh(refreshCart)
    refreshCart()
    cart.open()

def listSuppliers(hook):
    products = Menu(title="Suppliers")
    def refreshSupplier():
        query = "SELECT * FROM `supplier`"
        cursor.execute(query)

        products.set_options([])
        for product in cursor.fetchall():
            id = product[0]
            name = product[1]
            cname = product[2]
            products.add_option(f"#{id}: {name} - {cname}", hook, {"id": id, "name": name, "cname": cname})
    
        products.add_option("Back", Menu.CLOSE, {})
    
    products.set_refresh(refreshSupplier)
    refreshSupplier()
        
    products.open()

def listProducts(hook):
    products = Menu(title="Products")
    def refreshProducts():
        query = "SELECT * FROM `product`"
        cursor.execute(query)

        products.set_options([])
        for product in filter(lambda p : p[-1] == 0, cursor.fetchall()):
            product_id = product[0]
            product_name = product[1]
            product_price = product[3]
            products.add_option(
                f"{product_name} - {product_price}", 
                hook, 
                {"product_id": product_id, "product_name": product_name, 
                "product_price": product_price})
    
        products.add_option("Back", Menu.CLOSE, {})
    
    products.set_refresh(refreshProducts)
    refreshProducts()
        
    products.open()
    
    
def addProductCart(product_id, product_name, product_price):
    global sessionCart 
    
    for (i, (prid, _, _, _)) in enumerate(sessionCart):
        if prid == product_id:
            sessionCart[i][2] += 1
            return
        
    sessionCart.append([product_id, product_name, 1, product_price])
            

def removeProductCart(product_id):
    global sessionCart

    for (i, (prid, _, _, _)) in enumerate(sessionCart):
        if prid == product_id:
            sessionCart[i][2] -= 1
            if sessionCart[i][2] == 0:
                sessionCart.pop(i)
            return
        
    
def checkout():
    global sessionCart
    cursor.execute("SELECT COUNT(*) FROM orders;")
    order_id = cursor.fetchall()[0][0] + 1
    order_date = str(datetime.datetime.today()).split(" ")[0]
    order_number = random.randrange(10000, 99999)
    
    total_ammount = sum([i[3] for i in sessionCart])

    query = f'''
    INSERT INTO `orders`(`Id`, `OrderDate`, `OrderNumber`, `CustomerId`, `TotalAmount`) VALUES 
    ('{order_id}','{order_date}','{order_number}','{sessionID}','{total_ammount}')
    '''

    cursor.execute(query)

    cursor.execute("SELECT COUNT(*) FROM orderitem;")
    orderitem_id = cursor.fetchall()[0][0]+1

    for (pr_id, _, pr_quanity, _) in sessionCart:
        query = f'''
        INSERT INTO OrderItem (Id,OrderId,ProductId,Quantity)VALUES 
        ({orderitem_id},{order_id},{pr_id},{pr_quanity});
        '''
        cursor.execute(query)
        orderitem_id += 1
    
    con.commit()
    sessionCart.clear()

def editSupplier(id, **_):
    print("Enter the following info: ")

    query = f'''
    UPDATE `supplier`
    SET
    '''

    fields = ["SupplierName", "ContactName", "ContactTitle", "City", "Country", "Phone", "EmailId"]

    for field in fields:
        val = input(f"{field}: ")
        if val:
            query += f"`{field}` = {val},"

    query = query[:-1] + f''' 
    WHERE Id = {id}
    '''

    cursor.execute(query)
    con.commit()

def editProduct(id, **_):
    print("Enter the following info: ")

    query = f'''
    UPDATE `product`
    SET
    '''

    fields = ["Name", "SupplierId", "UnitPrice", "Package", "IsDiscontinued"]

    for field in fields:
        val = input(f"{field}: ")
        if val:
            query += f"`{field}` = {val},"

    query = query[:-1] + f''' 
    WHERE Id = {id}
    '''

    print(query)

    cursor.execute(query)
    con.commit()

def deleteSupplier(id, **_):
    query = f'''
    DELETE FROM `supplier`
    WHERE ID = {id}
    '''
    
    cursor.execute(query)
    con.commit()

def deleteProduct(id, **_):
    query = f'''
    DELETE FROM `product`
    WHERE ID = {id}
    '''
    
    cursor.execute(query)
    con.commit()

def getProduct(id):
    '''
    (ProductName, UnitPrice)
    '''

    query = f'''
    SELECT ProductName, UnitPrice FROM `Product` 
    WHERE Id = {id}
    '''

    cursor.execute(query)

    return cursor.fetchall()[0]

def displayOrder(id):
    query = f'''
    SELECT ProductId, Quantity FROM `orderitem` 
    WHERE OrderId = {id}
    '''

    cursor.execute(query)

    for index, orderItem in enumerate(cursor.fetchall()):
        product = getProduct(orderItem[0])
        print(f"\t{index+1}: {product[0]} - {product[1]} x {orderItem[1]}\n")

def orderHistory():
    print("Order Hstory\n\n")
    
    query = f'''
    SELECT * FROM orders
    WHERE CustomerId = {sessionID}
    '''

    cursor.execute(query)

    for order in cursor.fetchall():
        print(f"Order Number: {order[2]}\tDate: {order[1]}\tAmount: ₹{order[4]}\n")
        displayOrder(order[0])

    print("\n 1. Exit\n")

    
    inp = input(">>> ")
    if inp == "1":
        user.open()
    else:
        orderHistory()

admin = Menu(options=[("Add supplier", addNewSupplier), ("Delete supplier", listSuppliers, {"hook": deleteSupplier}), ("Edit supplier", listSuppliers, {"hook": editSupplier}), ("Add product", addNewProduct), ("Delete product", listProducts, {"hook": deleteProduct}), ("Edit product", listProducts, {"hook": editProduct}), (f"Sales \t\tToday: ₹{today_sales()}\tTotal: ₹{total_sales()}", total_sales), ("Logout", Menu.CLOSE)], title="Admin Page")
user = Menu(options=[("Browse products", listProducts, {"hook": addProductCart}), ("Veiw Cart", veiwCart), ("Order History", orderHistory), ("Logout", Menu.CLOSE)], title="Welcome!")

def adminAuth():
    passw = getpass.getpass(prompt="Enter admin password: ")
    if passw == "admin":
        admin.open()
    else:
        login.open()
    
def userAuth():
    global sessionID
    try:
        sessionID = int(input("Enter User ID: "))
        user.open()
    except:
        login.open()

login = Menu(options=[("Admin", adminAuth), ("User", userAuth), ("Exit", Menu.CLOSE)], title="Login")
login.open()