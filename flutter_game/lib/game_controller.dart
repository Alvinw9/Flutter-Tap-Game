import 'dart:math';
import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game/components/enemy_spawner.dart';
import 'package:flutter_game/components/health_bar.dart';
import 'package:flutter_game/components/player.dart';
import 'components/enemy.dart';

class GameController extends Game {

  Random rand;
  Size screenSize;
  double tileSize;
  Player player;
  EnemySpawner enemySpawner;
  List<Enemy> enemies;
  HealthBar healthBar;
  int score;

  GameController () {
    initialize();
  }

  void initialize() async {

    resize(await Flame.util.initialDimensions());
    rand = Random();
    player = Player(this);
    enemies = List<Enemy>();
    enemySpawner = EnemySpawner(this);
    healthBar = HealthBar(this);
    score = 0;

  }

  void render (Canvas c) {

    Rect background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint backgroundPaint = Paint()..color = Color(0xFFFAFAFA);
    c.drawRect(background, backgroundPaint);

    player.render(c);
    enemies.forEach((Enemy enemy) => enemy.render(c));
    healthBar.render(c);
    
  }

  void update (double t) {

    enemySpawner.update(t);
    enemies.forEach((Enemy enemy) => enemy.update(t));
    enemies.removeWhere((Enemy enemy) => enemy.isDead);
    player.update(t);
    healthBar.update(t);

  }

  void resize (Size size) {

    screenSize = size;
    tileSize = screenSize.width / 10;

  }

  void onTapDown (TapDownDetails d) {
    
    print(d.globalPosition);
    enemies.forEach((Enemy enemy) {

      if ( enemy.enemyRect.contains(d.globalPosition) ) {
        enemy.onTapDown();
      }

    });
  }

  void spawnEnemy() {
    
    double x, y;

    switch (rand.nextInt(4)) {

      // top
      case 0:
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;

      // right
      case 1:
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;

      // bottom
      case 2:
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height + tileSize * 2.5;
        break;

      // left
      case 3:
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;

    }

    enemies.add(Enemy(this, x, y));

  }

}