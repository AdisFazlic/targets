import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:targets/components/flies/fly.dart';
import 'package:targets/targetGameLoop.dart';
import 'package:flutter/material.dart';

class TargetFly extends Fly {
    double get speed => game.tileSize * 5;
    Paint particleAlivePaint = Paint()..color = Colors.green;
    Paint particleDeadPaint = Paint()..color = Colors.red;
  
  TargetFly(TargetGameLoop game, double x, double y) : super(game) {

  flyRect = Rect.fromLTWH(x, y, game.tileSize * 1.5, game.tileSize * 1.5); 
  flyingSprite = List<Sprite>();
  //flyingSprite.add(Sprite('flies/drooler-fly-1.png'));
  //flyingSprite.add(Sprite('flies/drooler-fly-2.png'));
  //deadSprite = Sprite('flies/drooler-fly-dead.png');
  }

  void render(Canvas c) {
   // c.drawCircle(new Offset(x,y), game.tileSize / 2, particleAlivePaint)
  }
}

