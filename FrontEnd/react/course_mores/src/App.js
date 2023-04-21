import flower from './flower.png';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={flower} className="App-logo" alt="logo" />
        <p>
          여기는 QR 코드에용
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
