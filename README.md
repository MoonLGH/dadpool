# TemplateTailwind

TemplateTailwind is a starter template for creating responsive and mobile-first web pages using [Tailwind CSS](https://tailwindcss.com/), a utility-first CSS framework, and [Parcel](https://parceljs.org/), a zero-configuration web application bundler.

## Features

- Uses Tailwind CSS for styling
- Includes [DaisyUI](https://daisyui.com/), a lightweight and elegant UI component library for Tailwind CSS
- Includes [Flowbite](https://flowbite.com/), a responsive HTML and CSS UI kit
- Uses Parcel for building and bundling the web application
- Includes Autoprefixer and PostCSS for vendor prefixing and optimizing the CSS
- Includes PurgeCSS for removing unused CSS styles in production builds

## Getting started

To get started with TemplateTailwind, follow these steps:

1. Clone the repository:
```sh
git clone https://github.com/MoonLGH/templatetailwind.git
```

2. Navigate to the project directory:
```sh
cd templatetailwind
```

3. Install the dependencies:
```sh
npm install
```

4. Start the development server:
```sh
npm run dev
```

This will start the development server and open the project in your default browser at `http://localhost:1234/`.
5. Start editing the source files in the `src/` directory. Changes will be automatically reloaded in the browser.

## Building for production

To build the project for production, run the following command:
```sh
npm run build
```

This will create a production-ready build of the project in the `dist/` directory.

By default, the built files will have relative URLs, which means that they should be served from the root directory of your web server. If you want to change this, you can use the `buildNotRoot` script:
```sh
npm run buildNotRoot
```

This will build the project with a custom public URL of `templateTailwind`, which means that the built files should be served from the `templateTailwind/` directory on your web server.

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file for more information.
