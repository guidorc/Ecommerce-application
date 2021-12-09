import React, { Component } from "react";
import Producto from "./ProductoEnCarrito";
import cartId from "./cartId";

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
    console.log(cartId.id);
    var response = await fetch(
      `http://localhost:8080/listCart?cartId=${cartId.id}`,
      {
        method: "GET",
      }
    );

    if (response.status == 200) {
      /* Actualizar el estado */
      var carrito = await response.json();
      console.log(carrito);
      this.setState({ productos: carrito });
    } else {
      /* Pedido Invalido */
      console.log(response);
    }
  };

  handleDelete = async (producto) => {
    let nuevosProductos = [...this.state.productos];
    let indice = nuevosProductos.indexOf(producto);

    if (
      window.confirm("Está seguro que desea quitar el elemento del carrito?")
    ) {
      /* request al servidor para quitar el producto del carrito */
      var response = await fetch(
        `http://localhost:8080/removeFromCart?cartId=${cartId.id}&bookIsbn=${producto.titulo}&bookQuantity=${producto.cantidad}`,
        { method: "GET" }
      );
      nuevosProductos.splice(indice, 1);
      this.setState({ productos: nuevosProductos });
    }
  };

  onBuyClick = (producto) => {};
}

export default CarritoDeCompras;
