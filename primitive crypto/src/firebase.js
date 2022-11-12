// Import the functions you need from the SDKs you need
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {

  /*apiKey: "AIzaSyBXUfmM2Y8JHeeO7rrTEVii5stlvy6DKas",
  authDomain: "crypto-listing-90950.firebaseapp.com",
  projectId: "crypto-listing-90950",
  storageBucket: "crypto-listing-90950.appspot.com",
  messagingSenderId: "899450072164",
  appId: "1:899450072164:web:dc1a4e72dcbe2420a38371"
  ^v^ Before placing the given ids in the .env ^v^
  */

  apiKey: process.env.REACT_APP_FIREBASE_API_KEY,
  authDomain: process.env.REACT_APP_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.REACT_APP_FIREBASE_PROJECT_ID,
  storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.REACT_APP_FIREBASE_MESSAGING_SENDER,
  appId: process.env.REACT_APP_FIREBASE_APP_ID,
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);

export default app;
