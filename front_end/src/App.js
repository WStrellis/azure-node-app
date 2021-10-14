import {useEffect,useState} from 'react'
import logo from './logo.svg';
import './App.css';

function App() {

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <ShowTime/>
      </header>
    </div>
  );
}

function useTime(delay=200){
  const [intervalID,setIntervalID] = useState(null)
  const [ currentTime,setCurrentTime ] = useState(new Date())

  useEffect(()=>{
   if (intervalID === null){
    setIntervalID(setInterval(()=>{
      setCurrentTime(new Date())
    },delay) )
   }
   return () => clearInterval(intervalID)
  }, [intervalID,delay])

  return currentTime
}

function ShowTime(){
  const current = useTime()
  return <span>{current.toLocaleString()}</span>
}
export default App;
