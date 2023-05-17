// import QR from "../public/coursemores_qr.png";
import "./App.css";
import PrivacyPolicy from "./PrivacyPolicy";
import { BrowserRouter as Router, Link, Route, Routes } from "react-router-dom";

export default function App() {
  return (
    <div className="App">
      <Router>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/policy" element={<PrivacyPolicy />} />
        </Routes>
      </Router>
    </div>
  );
}

function Home() {
  return (
    <header className="App-header">
      <img src="coursemores_qr.png" className="App-QR" alt="logo" width='300px' />
      <nav>
        <br/>
        <Link to="/policy">개인정보 처리방침</Link>
      </nav>
    </header>
  );
}

