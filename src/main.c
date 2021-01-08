#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "acia.h"
#include "ym2612.h"
#include "utils.h"
#include "Chaos_emerald.h"
#include "sn76489.h"
char c;
int line;
int note;
int song_posi = 0x100;
int bank = 0x8000;
int i;
int i2;
char CharL;
char CharH;
char playing;
char cmd;


void print_f(char * s){
  acia_put_newline();
  acia_puts(s);

}



void PlaySong(){
  playing = 1;
	while(playing == 1){
    //delay(1);
    cmd = getBytes();

    //acia_putc(cmd);
    switch (cmd) {
      case 0x50:
        sn_write_data(getBytes());
        break;
      case 0x52:
        ym_setreg(getBytes(),getBytes());
        break;
      case 0x53:
        ym_setreg_A1(getBytes(),getBytes());
        break;
      case 0x61:
        CharL = getBytes();
        CharH = getBytes();
        for (i=0; i <= CharH; ++i){
          for (i2 = 0; i2 <= CharL; ++i2){
            delay(1);
          }
        }
        break;
      case 0x62:
          delay(735);
        break;
      case 0x63:
          delay(835);
      break;
      case 0x70:
          delay(cmd-0x70+1);
      break;
      case 0x71:
          delay(cmd-0x70+1);
      break;
      case 0x72:
          delay(cmd-0x70+1);
      break;
      case 0x73:
          delay(cmd-0x70+1);
      break;
      case 0x74:
          delay(cmd-0x70+1);
      break;
      case 0x75:
          delay(cmd-0x70+1);
      break;
      case 0x76:
          delay(cmd-0x70+1);;
      break;
      case 0x77:
          delay(cmd-0x70+1);
      break;
      case 0x78:
          delay(cmd-0x70+1);
      break;
      case 0x79:
          delay(cmd-0x70+1);
      break;
      case 0x7A:
          delay(cmd-0x70+1);
      break;
      case 0x7B:
          delay(cmd-0x70+1);
      break;
      case 0x7C:
          delay(cmd-0x70+1);
      break;
      case 0x7D:
          delay(cmd-0x70+1);
      break;
      case 0x7E:
          delay(cmd-0x70+1);
      break;
      case 0x7F:
          delay(cmd-0x70+1);
      break;
      case 0x66:
        playing = 0;
        ym_init();
        sn_init();
        print_f("Konec songu");

      break;

    }
}


}


void main(void) {
  print_f("Appartus VGM Player Vas vita");
  ym_init();
  sn_init();
  init_read(Chaos_emerald+0x40);
  set_bank(0);
  //acia_putc(getBytes());
  PlaySong();

  while(1){
    c = acia_getc();
  switch (c){
    case 'S':
      acia_putc(getBytes());
    break;
    case 'W':
      print_f("Zacinam zapis.");
      write_to_BANK();
    break;

    case 'F':
      print_f("Formatuji Banky");
      format_bank();
    break;

    case 'P':
      set_bank(0);
      print_f("Spoustim song");
      //set_song_pos(0x0100);
      ym_init();
      init_read(0x8000+0x40);
      //play_song_from_bank(0x37,0x0);
      PlaySong();
    break;
    case '0':
      set_bank(0x0);
    break;
    case '1':
      set_bank(0x1);
    break;
    case '2':
      set_bank(0x2);
    break;
    case '3':
      set_bank(0x3);
    break;
    case '4':
      set_bank(0x4);
    break;
    case '5':
      set_bank(0x5);
    break;
    case '6':
      set_bank(0x6);
    break;
    case '7':
      set_bank(0x7);
    break;
  }
  }
}
