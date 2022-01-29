import React from "react";
import NavBar from "./NavBar";
import Historial from "./Historial";
import CarritoDeCompras from "./Carrito";
import Login from "./Login";
import Catalogo from "./Catalogo";
import NotMappedPage from "./NotMappedPAge";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";

function App() {
  return (
    <Router>
      <NavBar />
      <div className="container-fluid">
        <Routes>
          <Route path="/" element={<Login />} />
          <Route path="/catalogo" element={<Catalogo />} />
          {/*<Route path="/clientes" element={<ListaDeClientes />} />*/}
          <Route path="/carrito" element={<CarritoDeCompras />} />
          <Route path="/historial" element={<Historial />} />
          <Route path="*" element={<NotMappedPage />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
