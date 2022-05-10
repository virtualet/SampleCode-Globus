# Barebone project mocking INR_DEV

This is a barebone project meant to be used to make it easier to set-up a cloud
oriented CI.

This project is made of:
- `src/hello.cpp`: a simple C++ app printing `"Hello!"` on the standard output.
- `CMakeLists.txt`: a sample CMake project using the same tools we use for 
   INR_DEV: cmake, ninja, clang, Windows 10 SDK
- `Dockerfile`: the recipe for a Windows native container mocking system 
  requirements we expect for `INR_DEV`.


## How to build the container

From the project folder:

```powershell
docker.exe build -t "cloud-jenkins-barebone-project" .
```

## How to launch a shell inside the container

From the project folder:

```powershell
docker.exe run --volume "$($pwd):C:\project" -ti "cloud-jenkins-barebone-project"
```

Then from the inner shell you should have this project's folder mounted at 
`\Project`.
