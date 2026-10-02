# BoF documentation app

The documentation app for `breaks_on_fridays_ui`, with installation and styling
guides, interactive widget previews, and copyable Dart examples. Its responsive
layout includes a component sidebar, an on-page outline, and light/dark themes.

Use the sidebar to explore components, or press **Ctrl+K** (Windows/Linux) or
**⌘K** (macOS) to search. On narrow screens, open navigation with the menu button.
Pages have shareable hash routes, for example `/#/installation` and
`/#/components/button`. The browser's back and forward buttons retain navigation.

## Run locally

From the package root:

```sh
cd example
flutter pub get
flutter run -d chrome
```

## Build for the web

```sh
cd example
flutter build web --release
```

The result is `example/build/web`. Serve that directory using a local web server
to preview the release build; opening `index.html` directly is insufficient.

## Firebase Hosting

The package root contains a ready-to-use `firebase.json`. It serves
`example/build/web`, rewrites unknown paths to `index.html`, and asks browsers to
revalidate generated files so new documentation releases stay current. The
configuration does not select a Firebase project or deploy anything.

Choose or create your Firebase project, enable Hosting, and install the
[Firebase CLI](https://firebase.google.com/docs/cli). After building the app,
run these commands **from the package root**, replacing the project ID with
your actual Firebase project ID:

```sh
firebase login
firebase deploy --only hosting --project YOUR_FIREBASE_PROJECT_ID
```

The existing configuration is sufficient; running `firebase init hosting`
again can overwrite it. See the official
[Hosting configuration reference](https://firebase.google.com/docs/hosting/full-config)
for custom domains, caching, or additional hosting targets.

## Deploy manually from GitHub

The `Deploy web app to Firebase Hosting` workflow in
`.github/workflows/deploy-web.yml` runs only when manually triggered. It uses
Flutter 3.44.2 (Dart 3.12.2), analyzes and tests the documentation app, builds
`example/build/web`, and deploys to the Firebase project's default live Hosting
site using the root `firebase.json`.

Before the first run, enable Hosting in your Firebase project and add these in
your GitHub repository under **Settings → Secrets and variables → Actions**:

| Setting | Where to add it | Value |
| --- | --- | --- |
| `FIREBASE_PROJECT_ID` | Variables | Your Firebase project ID, not its display name. |
| `FIREBASE_SERVICE_ACCOUNT` | Secrets | The complete JSON key for a service account allowed to deploy Hosting in that project. |

For a static Hosting deploy, give that service account the **Firebase Hosting
Admin** and **API Keys Viewer** roles in the target project. Follow the Firebase
action's [service account setup guide](https://github.com/FirebaseExtended/action-hosting-deploy/blob/main/docs/service-account.md)
to create the account and generate its JSON key. Paste the key into the GitHub
secret; keep it out of the repository.

Commit the workflow to your repository's default branch so GitHub shows the
manual trigger. Open **Actions → Deploy web app to Firebase Hosting → Run
workflow**, choose the branch to deploy, and run it. The selected branch's source
is deployed to the live site; pushes and pull requests do not start this workflow.
