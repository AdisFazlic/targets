import 'package:targets/targetGameLoop.dart';
import 'package:targets/components/flies/fly.dart';


class FlySpawner {
  final TargetGameLoop game;
  final int maxSpawnInterval = 1000;
  final int minSpawnInterval = 150;
  final int intervalChange = 3;
  final int maxFliesOnScreen = 7;
  int currentInterval;
  int nextSpawn;

  FlySpawner(this.game) {
    start();
    game.spawnFly();

  }

  void start() {
    killAll();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;

  }

  void killAll() {
    game.flies.forEach((Fly fly) => fly.isDead = true); 
  }

  void update(double t) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;

    int livingFlies = 0;
    game.flies.forEach((Fly fly) {
      if (!fly.isDead) livingFlies += 1;
    });

    if (nowTimestamp >= nextSpawn && livingFlies < maxFliesOnScreen) {
      game.spawnFly();
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * .02).toInt();
      }
      nextSpawn = nowTimestamp + currentInterval;
    }
  }
}