from functools import wraps
import os

from flask import Flask, render_template, redirect, request
from flask.helpers import url_for
import pymysql

# Enviroment variables
cred = {"host": os.environ['MYSQL_HOST'],
        "user": os.environ['MYSQL_USER'],
        "password": os.environ['MYSQL_PASSWORD'],
        "database": os.environ['MYSQL_DATABASE']}

def test():
    client = pymysql.connect(host=cred["host"], user=cred["user"],
                password=cred["password"], database=cred["database"])
    cursor = client.cursor(pymysql.cursors.DictCursor)
    cursor.execute("SELECT VERSION()")
    print(cursor.fetchall())
    client.close()
    

app = Flask(__name__)


# Variables (make global in method if you are writing to it)
is_employee = False
is_loggedin = False
loggedinid = None
loggedinname = None


def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        global is_loggedin
        if is_loggedin == False:
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function


def supplier_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        global is_employee, is_loggedin
        if is_employee == False or is_loggedin == False:
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function


def supplier_not_allowed(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        global is_employee, is_loggedin
        if is_employee == True:
            if is_loggedin == True:
                return redirect(url_for('supplierhome'))
            else:
                return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function


@app.route('/error.html')
def error():
    return render_template('error.html')


@app.route("/index.html")
@app.route("/")
@supplier_not_allowed
def home():
    global is_loggedin, is_employee, loggedinid, loggedinname
    client = pymysql.connect(
        host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
    cursor = client.cursor(pymysql.cursors.DictCursor)
    query = "SELECT * FROM product where units_in_stock>0 LIMIT 8"
    cursor.execute(query)
    results = cursor.fetchall()
    return render_template('index.html', is_loggedin=is_loggedin, styles='home.css', loggedinname=loggedinname, products=results)


@app.route("/register.html", methods=['GET', 'POST'])
def signup():
    global is_loggedin, loggedinname
    if (is_loggedin):
        return redirect(url_for('home'))
    if request.method == 'POST':
        # create connection to db
        client = pymysql.connect(
            host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
        cursor = client.cursor()

        # obtain data from user form
        email = request.form['email']
        password = request.form['password']
        confirm_password = request.form['confirm_password']
        phone = request.form['phone']
        type = request.form['type']
        try:
            query = "call create_user(%s, %s, %s, %s, %s)"
            cursor.execute(
                query, (email, password, confirm_password, type, phone))
            client.commit()
        except Exception as e:
            print("Could not add entity to User Table")
            client.rollback()
            return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)

        if (type == "Supplier"):
            name = request.form['Name']
            add1 = request.form['Address_Line1']
            add2 = request.form['Address_Line2']
            city = request.form['City']
            state = request.form['State']
            zip = request.form['Zip']
            country = request.form['Country']
            try:
                query = "Select ID from user where email = %s"
                cursor.execute(query, email)
                id = cursor.fetchone()[0]
                query = "INSERT INTO supplier(Supplier_ID, Name, Address_Line1, Address_Line2, City, State, Zip, Country) values(%s, %s, %s, %s, %s, %s, %s, %s)"
                cursor.execute(query, (id, name, add1, add2,
                               city, state, zip, country))
                client.commit()
            except Exception as e:
                print("Could not add entity to Supplier Table", e)
                client.rollback()
                return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)
        else:
            firstName = request.form['firstName']
            lastName = request.form['lastName']
            try:
                query = "Select ID from user where email = %s"
                cursor.execute(query, email)
                id = cursor.fetchone()[0]
                query = "INSERT INTO buyer(Buyer_ID,First_Name, Last_Name) values(%s, %s, %s)"
                cursor.execute(query, (id, firstName, lastName))
                client.commit()
            except Exception as e:
                print("Could not add entity to Buyer Table", e)
                client.rollback()
                return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)

        # close connection
        client.close()
        return redirect(url_for('login'))
    return render_template('register.html', title='Sign Up')


@app.route("/login.html", methods=['GET', 'POST'])
def login():
    global loggedinid, loggedinname, is_employee, is_loggedin
    if (is_loggedin):
        return redirect(url_for('home'))
    if request.method == 'POST':
        client = pymysql.connect(
            host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
        cursor = client.cursor()

        email = request.form['email']
        password = request.form['password']

        try:
            # Check if customer
            cursor.callproc(
                'login_user', (email, password, 0, " ", False, False))
            cursor.execute(
                'SELECT @_login_user_2, @_login_user_3, @_login_user_4, @_login_user_5')
            res = cursor.fetchall()
            is_loggedin = res[0][3]
            is_employee = res[0][2]
            loggedinname = res[0][1]
            loggedinid = res[0][0]
            if is_loggedin:
                return redirect(url_for('supplierhome')) if is_employee else redirect(url_for('home'))
        except Exception as e:
            print("Can not retrieve specified Buyer/Supplier Entity", e)
            return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)
        finally:
            client.close()
    return render_template('login.html', title='Log In', styles='signin.css')


@app.route("/logout")
def logout():
    global is_loggedin, is_employee, loggedinid, loggedinname
    is_employee = False
    is_loggedin = False
    loggedinid = None
    loggedinname = None
    return redirect(url_for('home'))


@app.route("/supplier.html", methods=['GET', 'POST'])
@supplier_required
def supplierhome():
    global loggedinid, loggedinname, is_employee, is_loggedin
    client = pymysql.connect(
        host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
    cursor = client.cursor(pymysql.cursors.DictCursor)
    query = "select * from product where supplier_id=%s"
    cursor.execute(query, (loggedinid))
    product_list = cursor.fetchall()
    # print(product_list)
    return render_template('supplier.html', title='Supplier Area', products=product_list, is_loggedin=is_loggedin, loggedinname=loggedinname, is_employee=is_employee, styles='home.css')


@app.route("/editproduct.html", methods=['GET', 'POST'])
@supplier_required
def supplierProductEdit():
    global is_loggedin, is_employee, loggedinid, loggedinname
    if request.method == 'GET':
        product = None
        productid = request.args.get('productid')
        if productid != None:
            client = pymysql.connect(
                host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
            cursor = client.cursor(pymysql.cursors.DictCursor)
            query = "select * from product where Product_ID=%s"
            cursor.execute(query, (productid))
            product = cursor.fetchone()
            # print(product)
        return render_template('editproduct.html', title="Product Detail", product=product, is_loggedin=is_loggedin, loggedinname=loggedinname, is_employee=is_employee, styles='home.css')

    elif request.method == 'POST':
        client = pymysql.connect(
            host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
        cursor = client.cursor()
        # print(request.form)
        name = request.form['name']
        category = request.form['category']
        description = request.form['description']
        quantity = request.form['quantity']
        price = request.form['price']
        productid = - \
            1 if request.args.get(
                'productid') == None else request.args.get('productid')
        try:
            query = "call alter_product(%s,%s,%s,%s,%s,%s,%s)"
            print("call alter_product(%s,%s,%s,%s,%s,%s,%s)".format((loggedinid, name, category,
                                                                     description, quantity, price, productid)))
            cursor.execute(query, (loggedinid, name, category,
                                   description, quantity, price, productid))
            client.commit()
        except Exception as e:
            print("Can not insert that specific product", e)
            client.rollback()
            return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)
        finally:
            client.close()
        return redirect(url_for('supplierhome'))


@app.route("/products.html")
@supplier_not_allowed
def productListView(category='All'):
    global is_loggedin, is_employee, loggedinid, loggedinname
    client = pymysql.connect(
        host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
    cursor = client.cursor(pymysql.cursors.DictCursor)

    cat = request.args.get('category') if request.args.get(
        'category') != None else 'All'
    query = "call product_list(%s)"
    cursor.execute(query, (cat))
    product_list = cursor.fetchall()
    category = product_list[0]['Category'] if product_list[0]['Category'] == cat else "All"
    return render_template('productListView.html', category=category, products=product_list, is_loggedin=is_loggedin, loggedinname=loggedinname, is_employee=is_employee, styles='home.css')


@app.route("/productDetail.html", methods=['GET', 'POST'])
@supplier_not_allowed
def productDetailView():
    global is_loggedin, is_employee, loggedinid, loggedinname

    if request.method == 'GET':
        productID = request.args.get('id')
        client = pymysql.connect(
            host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
        cursor = client.cursor(pymysql.cursors.DictCursor)
        query = "select * from product where Product_ID=%s and units_in_stock>0"
        cursor.execute(query, productID)
        product = cursor.fetchone()
        query = "select * from review where product_id=%s"
        cursor.execute(query, productID)
        reviews = cursor.fetchall()
        print(reviews)
        client.close()
    else:
        try:
            # print(request.form)
            rating = request.form.get('rating')
            comment = request.form.get('comment')
            id = request.form.get('id')
            client = pymysql.connect(
                host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
            cursor = client.cursor(pymysql.cursors.DictCursor)
            query = "insert into review(product_id, buyer_id, rating, comment) values (%s,%s,%s,%s)"
            cursor.execute(query, (id, loggedinid, rating, comment))
            client.commit()
            return redirect(url_for('productDetailView', id=id))
        except Exception as e:
            print('Could not submit the review', e)
            client.rollback()
            return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)
        finally:
            client.close()

    return render_template('productDetailView.html', product=product, reviews=reviews, is_loggedin=is_loggedin, loggedinname=loggedinname, is_employee=is_employee, styles='home.css', scripts="home.js")


@app.route("/shoppingcart.html", methods=['GET', 'POST'])
@login_required
@supplier_not_allowed
def cart():
    global is_loggedin, is_employee, loggedinid, loggedinname
    if request.method == "POST":
        id = request.form['id']
        qty = request.form['quantity']
        try:
            client = pymysql.connect(
                host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
            cursor = client.cursor(pymysql.cursors.DictCursor)
            query = "call addtocart(%s,%s,%s)"
            cursor.execute(query, (id, loggedinid, qty))
            client.commit()
            if ('addtocart' in request.form):
                return redirect(url_for('productDetailView', id=id))
        except Exception as e:
            print('Couldnt add item to your cart', e)
            client.rollback()
            return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)
        finally:
            client.close()

    client = pymysql.connect(
        host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
    cursor = client.cursor(pymysql.cursors.DictCursor)
    if(request.args.get('action') == 'delete'):
        try:
            id = request.args.get('id')
            query = "call removefromcart(%s,%s)"
            cursor.execute(query, (id, loggedinid))
            client.commit()
        except Exception as e:
            print('Couldnt remove item to your cart', e)
            client.rollback()
            return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)

    query = "select * from product, shoppingcart where shoppingcart.Buyer_ID=%s and product.product_id=shoppingcart.product_id"
    cursor.execute(query, (loggedinid))
    products = cursor.fetchall()
    return render_template('shoppingcart.html', products=products, is_loggedin=is_loggedin, loggedinname=loggedinname, is_employee=is_employee, styles='home.css')


@app.route('/checkout.html')
@login_required
@supplier_not_allowed
def checkout():
    global is_loggedin, is_employee, loggedinid, loggedinname
    client = pymysql.connect(
        host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
    cursor = client.cursor(pymysql.cursors.DictCursor)
    query = "select * from address where Buyer_ID=%s"
    cursor.execute(query, (loggedinid))
    address = cursor.fetchall()
    query = "select * from payment where Buyer_ID=%s"
    cursor.execute(query, (loggedinid))
    payments = cursor.fetchall()

    try:
        if('checkout' == request.args.get('action')):
            payid = request.args.get('payid')
            addid = request.args.get('addid')
            query = "call checkout(%s,%s,%s)"
            cursor.execute(query, (loggedinid, payid, addid))
            client.commit()
            return redirect(url_for('thankyou'))
    except Exception as e:
        print("Couldn't complete the transaction", e)
        client.rollback()
        return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)
    finally:
        client.close()
    return render_template('checkout.html', address=address, payments=payments, is_loggedin=is_loggedin, loggedinname=loggedinname, styles='home.css', scripts='home.js')


@app.route('/thankyou.html')
@supplier_not_allowed
def thankyou():
    global is_loggedin, is_employee, loggedinid, loggedinname
    return render_template('thankyou.html', is_loggedin=is_loggedin, loggedinname=loggedinname, styles='home.css')


@app.route('/profile.html', methods=['GET', 'POST'])
@login_required
def profile():
    global is_loggedin, is_employee, loggedinid, loggedinname

    if request.method == 'GET':
        client = pymysql.connect(
            host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
        cursor = client.cursor(pymysql.cursors.DictCursor)
        if(not is_employee):
            query = "select email,date_created,type,phone_number,first_name,last_name,has_membership from user,buyer where ID=%s and user.id=buyer.buyer_id"
            cursor.execute(query, (loggedinid))
            user = cursor.fetchone()
        else:
            query = "select email, date_created, type, phone_number, Name, Address_Line1, Address_Line2, City, State, Zip, Country from user,supplier where ID=%s and user.id=supplier.supplier_id"
            cursor.execute(query, (loggedinid))
            user = cursor.fetchone()

        if request.args.get('action') == 'delete':
            query = 'delete from buyer where buyer_id=%s'
            cursor.execute(query, (loggedinid))
            client.commit()
            return redirect(url_for('logout'))
        client.close()

    elif request.method == 'POST':
        client = pymysql.connect(
            host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
        cursor = client.cursor(pymysql.cursors.DictCursor)
        try:
            email = request.form.get('email')
            phone = request.form.get('phone')
            query = "update user set email=%s, phone_number=%s where ID=%s"
            cursor.execute(query, (email, phone, loggedinid))
            client.commit()
        except Exception as e:
            print('Could not edit the user data', e)
            client.rollback()
            return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)

        if(not is_employee):
            try:
                first_name = request.form.get('firstName')
                last_name = request.form.get('lastName')
                query = "update buyer set first_name=%s, last_name=%s where Buyer_ID=%s"
                cursor.execute(query, (first_name, last_name, loggedinid))
                client.commit()
                return redirect(url_for('home'))
            except Exception as e:
                print('Could not edit the buyer data', e)
                client.rollback()
                return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)
            finally:
                client.close()
        else:
            try:
                Name = request.form.get('Name')
                Address_Line1 = request.form.get('Address_Line1')
                Address_Line2 = request.form.get('Address_Line2')
                Zip = request.form.get('Zip')
                City = request.form.get('City')
                State = request.form.get('State')
                Country = request.form.get('Country')
                query = "update supplier set Name=%s, Address_Line1=%s, Address_Line2=%s, Zip=%s, City=%s, State=%s, Country=%s where Supplier_ID=%s"
                cursor.execute(query, (Name, Address_Line1, Address_Line2,
                               Zip, City, State, Country, loggedinid))
                client.commit()
                return redirect(url_for('supplierhome'))
            except Exception as e:
                print('Could not edit the supplier data', e)
                client.rollback()
                return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)
            finally:
                client.close()
    return render_template('profile.html', user=user, is_loggedin=is_loggedin, loggedinname=loggedinname, is_employee=is_employee, styles='home.css')


@app.route('/settings.html', methods=['GET', 'POST'])
@login_required
def settings(redirecturl='settings'):
    global is_loggedin, is_employee, loggedinid, loggedinname

    client = pymysql.connect(
        host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
    cursor = client.cursor(pymysql.cursors.DictCursor)
    query = "select * from address where Buyer_ID=%s"
    cursor.execute(query, (loggedinid))
    address = cursor.fetchall()
    query = "select * from payment where Buyer_ID=%s"
    cursor.execute(query, (loggedinid))
    payments = cursor.fetchall()

    if request.method == "POST":
        if(request.args.get('redirecturl') != None):
            redirecturl = request.args.get('redirecturl')

        if(request.form.get('type') == 'Address'):
            add1 = request.form['Address_Line1']
            add2 = request.form['Address_Line2']
            city = request.form['City']
            state = request.form['State']
            zip = request.form['Zip']
            country = request.form['Country']
            try:
                query = "call alter_address(%s, %s, %s, %s, %s, %s, %s)"
                cursor.execute(query, (loggedinid, add1, add2,
                               city, state, zip, country))
                client.commit()
            except Exception as e:
                print("Couldn't add the address", e)
                client.rollback()
                return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)
            finally:
                client.close()
        elif(request.form.get('type') == 'Payment'):
            name = request.form['name']
            number = request.form['number']
            date = request.form['date']
            try:
                query = "call alter_payment(%s, %s, %s, %s)"
                cursor.execute(query, (loggedinid, name, number, date))
                client.commit()
            except Exception as e:
                print("Couldn't add the payment method", e)
                client.rollback()
                return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)
            finally:
                client.close()
        return redirect(url_for(redirecturl))
    return render_template('settings.html', is_loggedin=is_loggedin, loggedinname=loggedinname, address=address, payments=payments, styles='home.css')


@app.route('/wishlist.html')
@supplier_not_allowed
@login_required
def wishlist():
    global is_loggedin, is_employee, loggedinid, loggedinname

    client = pymysql.connect(
        host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
    cursor = client.cursor(pymysql.cursors.DictCursor)
    if (request.args.get('action') in ['insert', 'delete']):
        try:
            pid = request.args.get('pid')
            query = "call alter_wishlist(%s,%s,%s)"
            cursor.execute(
                query, (pid, loggedinid, request.args.get('action')))
            client.commit()
        except Exception as e:
            print("Could not add/delete the item to/from your wishlist", e)
            client.rollback()
            return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)
        if (request.args.get('redirecturl') != None):
            return redirect(url_for(request.args.get('redirecturl')))

    query = "select * from wishlist natural join product where Buyer_ID=%s"
    cursor.execute(query, (loggedinid))
    wishlist = cursor.fetchall()
    client.close()
    return render_template('wishlist.html', wishlist=wishlist, is_loggedin=is_loggedin, loggedinname=loggedinname, styles='home.css')


@app.route('/orders.html')
@supplier_not_allowed
@login_required
def orders():
    global is_loggedin, is_employee, loggedinid, loggedinname
    client = pymysql.connect(
        host=cred["host"], user=cred["user"], password=cred["password"], database=cred["database"])
    cursor = client.cursor(pymysql.cursors.DictCursor)
    if (request.args.get('action') == 'post'):
        try:
            pid = request.args.get('pid')
            oid = request.args.get('oid')
            qty = request.args.get('qty')
            query = "insert into orderreturns(product_id,order_id,quantity) values(%s,%s,%s)"
            cursor.execute(query, (pid, oid, qty))
            client.commit()
        except Exception as e:
            print('Could not process your return', e)
            client.rollback()
            return render_template('error.html', e=e, is_loggedin=is_loggedin, loggedinname=loggedinname)

    query = "select distinct order_has_product.order_id from order_has_product, buyerorder \
                where buyerorder.Buyer_ID=%s and buyerorder.order_id=order_has_product.order_id\
                order by Order_ID desc"
    cursor.execute(query, (loggedinid))
    numoforders = cursor.fetchall()
    query = "select bo.Order_ID, bo.Order_Date, bo.Delivery_Date, ohp.Quantity, p.Product_ID, p.Name, p.Price \
                from buyerorder bo, order_has_product ohp, product p \
                where bo.buyer_id=%s and bo.Order_ID=ohp.Order_ID and ohp.Product_ID=p.Product_ID \
                order by Order_ID desc;"
    cursor.execute(query, (loggedinid))
    results = cursor.fetchall()
    query = "select distinct orderreturns.order_id from orderreturns, buyerorder \
                where buyerorder.Buyer_ID=%s and buyerorder.order_id=orderreturns.order_id\
                order by Order_ID desc"
    cursor.execute(query, (loggedinid))
    numoforreturns = cursor.fetchall()
    query = "select bo.Order_ID, bo.Order_Date, bo.Delivery_Date, odr.Quantity, p.Product_ID, p.Name, p.Price \
                from buyerorder bo, orderreturns odr, product p \
                where bo.buyer_id=%s and bo.Order_ID=odr.Order_ID and odr.Product_ID=p.Product_ID \
                order by Order_ID desc;"
    cursor.execute(query, (loggedinid))
    returns = cursor.fetchall()
    client.close()

    return render_template('orders.html', numoforders=numoforders, results=results,
                           numoforreturns=numoforreturns, returns=returns,
                           is_loggedin=is_loggedin, loggedinname=loggedinname, styles='home.css')


if __name__ == '__main__':
    test()
    app.run()
