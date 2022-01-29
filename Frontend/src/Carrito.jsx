import React, { Component } from "react";
import Producto from "./ProductoEnCarrito";
import user_info from "./user_info";

class CarritoDeCompras extends Component {
  constructor(props) {
    // llamar al constructor de la superclase
    super(props);
    // Inicializar el estado
    this.state = {
      productos: [],
    };
  }

  render() {
    return (
      <div>
        <h4>Carrito</h4>
        <div className="row">
          {this.state.productos.map((prod) => {
            return (
              <Producto
                key={prod.id}
                producto={prod}
                onDelete={this.handleDelete}
              ></Producto>
            );
          })}
        </div>
        <button className="btn btn-primary" onClick={this.onBuyClick}>
          Comprar
        </button>
      </div>
    );
  }

  componentDidMount = async () => {
    /* Obtener el Carrito */
    this.getCart();
  };

  handleDelete = async (producto) => {
    if (
      window.confirm("Está seguro que desea quitar el elemento del carrito?")
    ) {
      /* request al servidor para quitar el producto del carrito */
      var response = await fetch(
        `http://localhost:8080/removeFromCart?cartId=${user_info.cartId}&bookIsbn=${producto.titulo}&bookQuantity=${producto.cantidad}`,
        { method: "GET" }
      );
      if (!response.ok) {
        console.log(response);
      }
    }

    /* obtener el carrito actualizado */
    this.getCart();
  };

  getCart = async () => {
    /* Request al servidor por el listado del carrito */
    var response = await fetch(
      `http://localhost:8080/listCart?cartId=${user_info.cartId}`,
      {
        method: "GET",
      }
    );

    if (response.ok) {
      /* Actualizar el estado */
      var carrito = await response.json();
      this.setState({ productos: carrito });
    } else {
      /* Pedido Invalido */
      console.log(response);
    }
  };

  onBuyClick = async (producto) => {
    /* Request al servidor para comprar el carrito */
    var response = await fetch(
      `http://localhost:8080/checkoutCart?cartId=${user_info.cartId}&ccn=1111222233334444&cced=11/2022&cco=Juan Perez`,
      {
        method: "GET",
      }
    );

    if (response.ok) {
      /* Actualizar el estado */
      window.alert("La compra fué realizada con éxito!");
      this.getCart();
    } else {
      /* Pedido Invalido */
      window.alert("No se pudo realizar la compra.");
      console.log(response);
    }
  };
}

export default CarritoDeCompras;
