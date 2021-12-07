import React, { Component } from "react";
import { Link } from "react-router-dom";

class NavBar extends Component {
  render() {
    return (
      <React.Fragment>
        <nav className="navbar navbar-expand-lg navbar-dark bg-dark navbar-style">
          <div>
            <a className="navbar-brand" href="/#">
              Amazonas
            </a>
            <button
              className="navbar-toggler"
              type="button"
              data-bs-toggle="collapse"
              data-bs-target="#navbarSupportedContent"
              aria-controls="navbarSupportedContent"
              aria-expanded="false"
              aria-label="Toggle navigation"
            >
              <span className="navbar-toggler-icon"></span>
            </button>
            <div
              className="collapse navbar-collapse"
              id="navbarSupportedContent"
            >
              <ul className="navbar-nav me-auto mb-2 mb-lg-0">
                <li className="nav-item">
                  <Link to="/" className="nav-link">
                    Ingresar
                  </Link>
                </li>
                <li className="nav-item">
                  <Link to="/carrito" className="nav-link">
                    Carrito
                  </Link>
                </li>
                <li className="nav-item">
                  <Link to="/catalogo" className="nav-link">
                    Catalogo
                  </Link>
                </li>
                <li className="nav-item">
                  <Link to="/clientes" className="nav-link">
                    Clientes
                  </Link>
                </li>
              </ul>
            </div>
          </div>
        </nav>
      </React.Fragment>
    );
  }
}

export default NavBar;
