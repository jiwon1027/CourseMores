import flower from "./flower.png";
import "./App.css";
import PrivacyPolicy from "./PrivacyPolicy";
import { BrowserRouter as Router, Link, Route, Routes } from "react-router-dom";

function App() {
  return (
    <div className="App">
      <Router>
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
          <Routes>
            <Route path="/policy" element={<PrivacyPolicy />} />
          </Routes>
        </header>
      </Router>
    </div>
  );
}

export default App;
