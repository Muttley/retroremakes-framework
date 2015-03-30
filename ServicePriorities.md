# Introduction #

This section gives a breakdown of the current server priorities.

Each of the Game Services included in the engine have priorities set for different service calls.  This allows us to ensure that service facilities are initialised and run in the correct order where required.  Services with the same priorities are run in the order they are instantiated.

If you create your own services you can therefore ensure that they do not start before any services that they rely upon.  If you don't specify a priority default values of 0 will be used.

# Details #

## Service Start Priorities ##

This is the order that services are started when rrEngineRun is called.

| **Service Name** | **Priority** |
|:-----------------|:-------------|
| TGraphicsService | -9999 |
| TFramesPerSecond | 0 |
| TColourOscillator | 0 |
| TScaleOscillator | 0 |
| TGameSoundHandler | 0 |
| TInputManager | 0 |

## Service Update Priorities ##

This is the order that each service's Update() method is called during each logic loop.

| **Service Name** | **Priority** |
|:-----------------|:-------------|
| TInputManager | -1000 |
| TMessageService | -100 |
| TGameSoundHandler | 0 |
| TScoreService | 0 |
| TLayerManager | 0 |

## Service Render Priorities ##

This is the order that each service's Render() method is called during each logic loop.

| **Service Name** | **Priority** |
|:-----------------|:-------------|
| TLayerManager | 0 |

## Service Debug Update Priorities ##

This is the order that each service's DebugUpdate() method is called during each logic loop.

| **Service Name** | **Priority** |
|:-----------------|:-------------|
| TConsole | 0 |
| TProfiler| 1000 |

## Service Debug Render Priorities ##

This is the order that each service's DebugRender() method is called during each logic loop.

| **Service Name** | **Priority** |
|:-----------------|:-------------|
| TConsole | 0 |
| TProfiler| 1000 |