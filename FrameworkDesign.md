# Introduction #

The **RetroRemakes Framework** is a 2D Game Engine written in **BlitzMax**.  It's main goal is to provide an efficient and easy to use set of services to enable the rapid development of 2D retro-style games.

The framework has been developed as a **BlitzMax Module**, which can be imported and used immediately with a minimal amount of configuration.  For example, at the most basic level you can create a running instance of the engine as follows:

```
Import retroremakes.rrfw

rrEngineRun()
```

This will instantiate the engine and create a default 800x600x16 windowed display.  See the UserGuide for more details on how to use the engine.

The **RetroRemakes Framework** uses OO design patterns to provide a variety of services to the game developer.  Additionally it has a selection of HelperFunctions which can be used by developers who prefer a more procedural approach, however some knowledge of BlitzMax Types, overloading and inheritance is required due to the way that the engine handles GameStates.

# Design #

The main Type or Class in the Framework is the [TGameEngine](TGameEngine.md).  This is a [Singleton Type](http://en.wikipedia.org/wiki/Singleton_pattern) which is instanced when the framework is imported (so the user doesn't have to).

When [TGameEngine](TGameEngine.md) is initialised it creates instances of the core GameServices, such as [TGameSettings](TGameSettings.md), [TResourceManager](TResourceManager.md), [TGameSoundHandler](TGameSoundHandler.md), etc.  These are are all children of the [TGameService](TGameService.md) Type.

When any [TGameService](TGameService.md) Type is initialised it registers with the Engine instance, and as part of the registration process the Engine uses [Reflection](http://en.wikipedia.org/wiki/Reflection_(computer_science)) to discover if the registering service has any of the following methods: **Update**, **DebugUpdate**, **Render**, **DebugRender**

If any of these methods exist the [TGameService](TGameService.md) is added to the relevant TLists used by the Engine's MainLoop.  Each Service can also have a ServicePriority assigned, so that you can ensure Services are run in a specific order if required.

It is also possible for additional GameServices to be created and registered with the Engine if required.