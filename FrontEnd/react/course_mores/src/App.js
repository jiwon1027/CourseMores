import "./App.css";
import Home from "./Components/Home";
import PrivacyPolicy from "./Components/PrivacyPolicy";
import { BrowserRouter as Router, Link, Route, Routes } from "react-router-dom";

function App() {
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

export default App;
