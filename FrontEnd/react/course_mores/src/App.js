import flower from "./flower.png";
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
      <img src={flower} className="App-logo" alt="logo" />
      <p>여기는 QR 코드에용</p>
      <nav>
        <ul>
          <li>
            <Link to="/policy">개인정보 처리방침</Link>
          </li>
        </ul>
      </nav>
    </header>
  );
}
