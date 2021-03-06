import 'dart:ui';
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/particle.dart';
import 'package:flame/particles/accelerated_particle.dart';
import 'package:flame/particles/circle_particle.dart';
import 'package:flutter/material.dart';
import 'package:targets/components/flies/fly.dart';
import 'package:targets/components/flies/house-fly.dart';
import 'package:targets/components/flies/agile-fly.dart';
import 'package:targets/components/flies/drooler-fly.dart';
import 'package:targets/components/flies/hunger-fly.dart';
import 'package:targets/components/flies/macho-fly.dart';
import 'package:targets/components/backyard.dart';
import 'package:targets/components/targets/target-particle.dart';
import 'package:targets/components/targets/face-particle.dart';

import 'package:targets/views/view.dart';
import 'package:targets/views/home-view.dart';
import 'package:targets/views/lost-view.dart';
import 'package:targets/views/help-view.dart';
import 'package:targets/views/credits-view.dart';
import 'package:targets/components/buttons/start-button.dart';
import 'package:targets/components/buttons/credits-button.dart';
import 'package:targets/components/buttons/help-button.dart';
import 'package:targets/controllers/fly-spawner.dart';
import 'controllers/target-spawner.dart';
import 'package:flame/components/particle_component.dart';




class TargetGameLoop extends BaseGame {
  bool hasWon = false;
  bool gameStarted = false;
  double tileSize;
  bool isInitialized = false;
  List<Fly> flies = [];
  List<TargetParticle> targets = [];
  Random rnd;
  Backyard background;
  View activeView = View.home;
  HomeView homeView;
  LostView lostView;
  HelpView helpView;
  CreditsView creditsView;
  StartButton startButton;
  HelpButton helpButton;
  CreditsButton creditsButton;
  FlySpawner flySpawner;
  TargetSpawner targetSpawner;

void spawnTarget(){
  targets.add(TargetParticle(this));
}


    void spawnFly() {
    double x = rnd.nextDouble() * (size.width - (tileSize * 2.025));
    double y = rnd.nextDouble() * (size.height - (tileSize * 2.025));
    
    switch (rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(DroolerFly(this, x, y));
        break;
      case 2:
        flies.add(AgileFly(this, x, y));
        break;
      case 3:
        flies.add(MachoFly(this, x, y));
        break;
      case 4:
        flies.add(HungryFly(this, x, y));
        break;
    }
  }

  void render(Canvas canvas) {
    if (!isInitialized) {
      tileSize = size.width / 9;
      rnd = Random();    
      background = Backyard(this);  
      isInitialized = true;  
      homeView = HomeView(this);
      lostView = LostView(this);
      helpView = HelpView(this);
      creditsView = CreditsView(this);

      startButton = StartButton(this);   
      helpButton = HelpButton(this);
      creditsButton = CreditsButton(this);  
      //flySpawner = FlySpawner(this);
      targetSpawner = TargetSpawner(this);

    } // initialisation done

    background.render(canvas);
   
    //flies.forEach((Fly fly) => fly.render(canvas));
    targets.forEach((TargetParticle tp) => tp.render(canvas));
    
    if (activeView == View.home) {
      homeView.render(canvas);
    }
    if(activeView == View.lost) {
      lostView.render(canvas);
    }
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);

    }
    

    if (activeView == View.help) {
      helpView.render(canvas);
    }
    if (activeView == View.credits) {
      creditsView.render(canvas);
    }
    

  }


  void update(double t) {
  //flies.forEach((Fly fly) => fly.update(t));
  //flies.removeWhere((Fly fly) => fly.isOffScreen);
  //flySpawner.update(t);
    targets.forEach((TargetParticle tp ) => tp.update(t));
    targets.removeWhere((TargetParticle tp ) => tp.isOffScreen);
    
    targetSpawner.update(t);

  }

  void onTapDown(TapDownDetails d) {
    
   bool isTapDownHandled = false;
   bool didHitFly = false;
   bool didHitTarget = false;

   // start button
   if(!isTapDownHandled && startButton.rect.contains(d.globalPosition)) {
     if(activeView == View.home || activeView == View.lost){
       startButton.onTapDown();
       isTapDownHandled = true;
     }
   }

   // flies

    // activeView == View.playing is not part of tutorial
    // in tutorial one can hit flies before starting game, but makes not sense, 
    // so I made it to not be able to hit flies until the game is started
    /*
    if(!isTapDownHandled &&  (activeView == View.playing)) {
      flies.forEach((Fly fly) {
        if (fly.flyRect.contains(d.globalPosition)) {
          fly.onTapDown();
          isTapDownHandled = true;
          didHitFly = true; 
          print('didHitFly -  $didHitFly');
        }
      });
      
    }
    */

      if(!isTapDownHandled &&  (activeView == View.playing)) {
      targets.forEach((TargetParticle tp) {
        if (tp.targetRect.contains(d.globalPosition)) {
          tp.onTapDown();
          isTapDownHandled = true;
          didHitTarget = true; 
          print('didHitFly - $didHitTarget');
        }
      });
      
    }

    // exclude code so can't loose
    /*
     if(!isTapDownHandled && activeView == View.playing && gameStarted && !didHitFly) {
      activeView = View.lost;
      print('didHitFly - '  + didHitFly.toString());
      gameStarted = false;
      isTapDownHandled = true;
    }
    */

  if(!isTapDownHandled && activeView == View.playing && gameStarted && !didHitTarget) {
        activeView = View.lost;
        print('didHitTarget - $didHitTarget');
        gameStarted = false;
        isTapDownHandled = true;
      }

    // help button
if (!isTapDownHandled && helpButton.rect.contains(d.globalPosition)) {
  if (activeView == View.home || activeView == View.lost) {
    helpButton.onTapDown();
    isTapDownHandled = true;
  }
}

// credits button
if (!isTapDownHandled && creditsButton.rect.contains(d.globalPosition)) {
  if (activeView == View.home || activeView == View.lost) {
    creditsButton.onTapDown();
    isTapDownHandled = true;
  }
}

// when inside help or credits, click anywhere to go to home view
if (!isTapDownHandled) {
  if (activeView == View.help || activeView == View.credits) {
   activeView = View.home;
    isTapDownHandled = true;
  }
}

  
  }
}
