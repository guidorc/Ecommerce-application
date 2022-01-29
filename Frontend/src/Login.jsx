import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import user_info from "./user_info";

function Login() {
  let navigate = useNavigate();

  const [user, setUser] = useState("");
  const [password, setPassword] = useState("");
  const [msg, setMsg] = useState("");
  const [logged, setLogged] = useState(false);

  const onLoginClick = async () => {
    /* Envio pedido de login con datos ingresados */
    var response = await fetch(
      `http://localhost:8080/createCart?clientId=${user}&password=${password}`,
      { method: "GET" }
    );

    if (response.ok) {
      /* Login Valido */
      var id_del_carrito = await response.json();
      user_info.cartId = id_del_carrito;
      user_info.username = user;
      user_info.password = password;
      setMsg(<span className="text-success">Login válido!</span>);
      setLogged(true);
      /* Redireccion a catálogo */
      navigate("/catalogo");
    } else {
      /* Login invalido */
      setMsg(<span className="text-danger">Login inválido</span>);
    }
  };

  return (
    <div className="col-lg-9">
      <h4 className="m-1 p-2 border-bottom">Login</h4>
      {/* Casilla de Usuario */}
      <div className="form-group form-row">
        <label className="col-lg-3">Usuario:</label>
        <input
          type="text"
          className="form-control"
          value={user}
          onChange={(event) => {
            setUser(event.target.value);
          }}
        />
      </div>

      {/* Casilla de Contraseña */}
      <div className="form-group form-row">
        <label className="col-lg-3">Contraseña:</label>
        <input
          type="password"
          className="form-control"
          value={password}
          onChange={(event) => {
            setPassword(event.target.value);
          }}
        />
      </div>

      {/* Botón de Login */}
      <div className="text-right">
        {msg}
        <button className="btn btn-primary m-2" onClick={onLoginClick}>
          Ingresar
        </button>
      </div>
    </div>
  );
}

export default Login;
