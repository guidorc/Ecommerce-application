import React, { Component } from "react";

class Login extends Component {
  constructor(props) {
    super(props);
    this.state = {
      usuario: "",
      contraseña: "",
      mensaje: "",
      logueado: false,
    };
  }

  render() {
    return (
      <div className="col-lg-9">
        <h4 className="m-1 p-2 border-bottom">Login</h4>
        {/* Casilla de Usuario */}
        <div className="form-group form-row">
          <label className="col-lg-3">Usuario:</label>
          <input
            type="text"
            className="form-control"
            value={this.state.usuario}
            onChange={(event) => {
              this.setState({ usuario: event.target.value });
            }}
          />
        </div>

        {/* Casilla de Contraseña */}
        <div className="form-group form-row">
          <label className="col-lg-3">Contraseña:</label>
          <input
            type="password"
            className="form-control"
            value={this.state.contraseña}
            onChange={(event) => {
              this.setState({ contraseña: event.target.value });
            }}
          />
        </div>

        {/* Botón de Login */}
        <div className="text-right">
          {this.state.mensaje}
          <button className="btn btn-primary m-2" onClick={this.onLoginClick}>
            Ingresar
          </button>
        </div>
      </div>
    );
  }

  onLoginClick = async () => {
    /* Envio pedido de login con datos ingresados */
    var response = await fetch(
      `http://localhost:8080/createCart?clientId=${this.state.usuario}&password=${this.state.contraseña}`,
      { method: "POST" }
    );

    if (response.status == 200) {
      /* Login Valido */
      this.setState({
        mensaje: <span className="text-success">Login válido!</span>,
      });
    } else {
      /* Login invalido */
      this.setState({
        mensaje: <span className="text-danger">Login inválido</span>,
      });
    }
  };
}

export default Login;
