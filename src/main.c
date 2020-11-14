#include <stdlib.h>
#include <stdio.h>
#include <string.h>


#include "acia.h"
#include "ym2612.h"
#include "utils.h"
#include "song.h"
#include "Chaos_emerald.h"
//#include "vdp_low.h"
//#include "test.h"
//#include "bank.h"
//#include "wait.h"
//
//#include "utils.h"
//#include "wood_char.h"
//#include "sprite.h"
//#include "copyshort.h"

//#include "spi.h"
char c;
int line;
int note;
int song_posi = 0x100;
int bank = 0x8000;
int i;
int i2;
int CharL;
int CharH;
int playing;
char cmd;


void print_f(char * s){
  acia_put_newline();
  acia_puts(s);

}

char getByt(char data[]){
  ++song_posi;
  if (song_posi == 0x4000){
    song_posi = 0;
    switch_bank();
  }
acia_putc(data[song_posi]);
delay();
  return data[song_posi];
}


void PlaySong(char data[]){
  playing = 1;
	while(playing == 1){
    //delay();
    cmd = getByte(data);
    switch (cmd) {
      case 0x50:
        CharL = getByte(data);
        delay();
        break;
      case 0x52:
        CharL = getByte(data);
        CharH = getByte(data);
        ym_setreg(CharL,CharH);
        //acia_puts("Wr_A0_");
        //acia_putc(CharL);
        //acia_putc(CharH);
        //acia_put_newline();
        break;
      case 0x53:
      CharL = getByte(data);
      CharH = getByte(data);
      ym_setreg_A1(CharL,CharH);
      //acia_puts("Wr_A1_");
      //acia_putc(CharL);
      //acia_putc(CharH);
      //acia_put_newline();
        break;
      case 0x61:
        CharL = getByte(data);
        CharH = getByte(data);
        //acia_puts("Wait ");
        //acia_putc(CharL);
        //acia_putc(CharH);
        //acia_puts("H ms");
        //acia_put_newline();
        for (i=0; i <= CharH; ++i){
          for (i2 = 0; i2 <= CharL; ++i2){
            delay();
          }
        }
        break;
      case 0x62:
        for (i = 0; i <= 735; ++i){
          delay();
        }
        break;
      case 0x63:
        for (i = 0; i <= 835; ++i){
          delay();
        }
          break;
      case 0x70:
        for (i=1; i <= 1; ++i){
          delay();
        }
        break;
      case 0x71:

          for (i=1; i <= 2; ++i){
            delay();
          }
          break;
      case 0x72:
          for (i=1; i <= 3; ++i){
            delay();
          }
          break;
      case 0x73:
          for (i=1; i <= 4; ++i){
            delay();
          }
          break;
      case 0x74:
          for (i=1; i <= 5; ++i){
            delay();
          }
          break;
      case 0x75:
          for (i=1; i <= 6; ++i){
            delay();
          }
          break;
      case 0x76:
          for (i=1; i <= 7; ++i){
            delay();
          }
          break;
      case 0x77:
          for (i=1; i <= 8; ++i){
            delay();
          }
          break;
          case 0x78:
              for (i=1; i <= 9; ++i){
                delay();
              }
              break;
          case 0x79:
              for (i=1; i <= 10; ++i){
                delay();
              }
              break;
          case 0x7A:
              for (i=1; i <= 11; ++i){
                delay();
              }
              break;
          case 0x7B:
              for (i=1; i <= 12; ++i){
                delay();
              }
              break;
          case 0x7C:
              for (i=1; i <= 13; ++i){
                delay();
              }
              break;
          case 0x7D:
              for (i=1; i <= 14; ++i){
                delay();
              }
              break;
          case 0x7E:
              for (i=1; i <= 15; ++i){
                delay();
              }
              break;
          case 0x7F:
            for (i=1; i <= 16; ++i){
              delay();
            }
            break;
      case 0x66:
        playing = 0;
        //set_song_pos(0x0100);
        ym_init();
        print_f("Konec songu");

      break;

    }
}


}


void main(void) {
  print_f("Appartus VGM Player Vas vita");
  line = 0;
  note = 0;
  ym_init();
  PlaySong(Chaos_emerald);
  while(1){
    c = acia_getc();
  switch (c){
    case 'W':
      print_f("Zacinam zapis.");
      write_to_BANK();
    break;

    case 'F':
      print_f("Formatuji Banky");
      format_bank();
    break;

    case 'P':
      print_f("Spoustim song");
      //set_song_pos(0x0100);
      ym_init();
      play_song_from_bank(0x37,0x0);
      PlaySong(Chaos_emerald);
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
