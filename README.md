<div align="center">
    <img src="./delibrary/lib/assets/3.0x/logo.png" title="Delibrary" width="75%"/>
</div>

<br />
<p align="center">
  <h1 align="center">Delibrary</h1>

  <p align="center">
    Project developed for the final exam of the course named <em>Design and Implementation of Mobile Applications</em> held by Professor Luciano Baresi at <em>Politecnico di Milano</em>.
    <br />
    <a href="https://github.com/lorenzofratus/delibrary"><strong>Explore the docs »</strong></a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This project has been developed as final assignment for the _Design and Implementation of Mobile Applications_ course held by Professor Luciano Baresi at _Politecnico di Milano_.

The objective of this project was to build a multi-platform mobile application using a framework of choice among Flutter, React Native, Kotlin, and Swift.

Delibrary is a mobile application designed to encourage the exchange of physical books.

A user can publish their own books on Delibrary, point out books they would like to own and propose exchanges to other users.
Delibrary is in charge of connecting users interested in a book exchange.

Finally, the idea is to create a _"decentralized library"_, in which readers are encouraged to immerse themselves
in ever new adventures and to be part of a community of book enthusiasts.

At the moment, Delibrary has been developed for the Italian market, for this reason, the UI is in Italian.

The system is supported by a server built with _Express.js_ and a _PostgreSQL_ database, both are hosted on _Heroku_.

The code of the server can be found at this [link](https://github.com/lorenzofratus/delibrary-server).

### Built With

* [Flutter](https://flutter.dev), v. 2.0.4
* [Dart](https://dart.dev)



<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites


You need to have installed on your machine version 2.0.4 of Flutter.
This step can be done following the guide provided in the documentaion of the framework:

<div align="center">

  [![Open GUIDE](https://img.shields.io/badge/Open-GUIDE-black.svg?style=for-the-badge&colorB=555)](https://flutter.dev/docs/get-started/install)

</div>

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/lorenzofratus/Delibrary.git
   ```
2. Open the project in your IDE of choice
   
3. Connect your device in **debug mode** or open a simulator
4. Move into the `delibrary` folder
   ```sh
   cd delibrary
   ```
5. Install the application on the device
   ```sh
   flutter run lib/src/main.dart --release
   ```
   **Note** that the `release` mode will not work on simulators.

<!-- LICENSE -->
## License

Distributed under the [GNU GPLv3 License](LICENSE).



<!-- CONTACT -->
## Contact

<div align="center">
  <h3>Lorenzo Fratus</h3>

  [![Website](https://img.shields.io/badge/-Website-black.svg?style=for-the-badge&logo=html5&colorB=555)](https://www.lorenzofratus.it/)
  [![Email](https://img.shields.io/badge/-Email-black.svg?style=for-the-badge&logo=gmail&colorB=555)](mailto:info@lorenzofratus.it)
  [![LinkedIn](https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555)](https://www.linkedin.com/in/lorenzo-fratus/)

  <h3>Nicolò Sala</h3>

  [![Github](https://img.shields.io/badge/-Github-black.svg?style=for-the-badge&logo=github&colorB=555)](https://github.com/nicheosala)


Project Link: [https://github.com/lorenzofratus/delibrary](https://github.com/lorenzofratus/delibrary)

</div>
