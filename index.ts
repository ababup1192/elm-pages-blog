type ElmPagesInit = {
  load: (elmLoaded: Promise<unknown>) => Promise<void>;
  flags: unknown;
};

import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getAuth, GoogleAuthProvider, onAuthStateChanged, signInWithRedirect, signOut } from "firebase/auth";

const firebaseConfig = {
  // todo: config 入れたら動く
};

const firebaseApp = initializeApp(firebaseConfig);
const auth = getAuth(firebaseApp);

const analytics = getAnalytics(firebaseApp);

const config: ElmPagesInit = {
  load: async function (elmLoaded) {
    const app = await elmLoaded as any;
    console.log("App loaded", app);

    onAuthStateChanged(auth, (user) => {
      if (user != null) {
        console.log("onAuthStateChanged: user is not null");
        app.ports.updateLoginStatus.send("signIn");
      } else {
        console.log("onAuthStateChanged: user is null");
      }
    });

    app.ports.signIn.subscribe(async () => {
      const provider = new GoogleAuthProvider()
      await signInWithRedirect(auth, provider)
    });

    app.ports.signOut.subscribe(async () => {
      const provider = new GoogleAuthProvider()
      await signOut(auth);
      app.ports.updateLoginStatus.send("signOut");
    });
  },
  flags: function () {
    return "You can decode this in Shared.elm using Json.Decode.string!";
  },
};

export default config;
