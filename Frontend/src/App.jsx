import React, { Component } from "react";
import NavBar from "./NavBar";
import ListaDeClientes from "./Clientes";
import CarritoDeCompras from "./Carrito";
import Login from "./Login";
import Catalogo from "./Catalogo";
import NotMappedPage from "./NotMappedPAge";
import { BrowserRouter, Routes, Route } from "react-router-dom";

class App extends Component {
  render() {
    return (
      <BrowserRouter>
        <NavBar />
        <div className="container-fluid">
          <Routes>
            <Route path="/" element={<Login />} />
            <Route path="/catalogo" element={<Catalogo />} />
            <Route path="/clientes" element={<ListaDeClientes />} />
            <Route path="/carrito" element={<CarritoDeCompras />} />
            <Route path="*" element={<NotMappedPage />} />
          </Routes>
        </div>
      </BrowserRouter>
    );
  }
}

export default App;
