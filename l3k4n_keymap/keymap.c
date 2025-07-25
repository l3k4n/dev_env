#include <stdint.h>
#include QMK_KEYBOARD_H
#include "version.h"
#define MOON_LED_LEVEL LED_LEVEL
#define ML_SAFE_RANGE SAFE_RANGE

enum layer_id {
  LAYER_ID_BASE = 0,
  LAYER_ID_SHIFT,
  LAYER_ID_MEDIA,
  LAYER_ID_QWERTY,
  LAYER_ID_FUNCTION,
};

// enum custom_keycodes {
//     MY_CUSTOM_KC = ML_SAFE_RANGE,
// };

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    // base
    [LAYER_ID_BASE] = LAYOUT_moonlander(
        KC_TRANSPARENT, KC_EXLM, KC_LBRC, KC_LPRN, KC_LCBR, KC_PERC,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_PIPE, KC_RCBR, KC_RPRN, KC_RBRC,
        KC_HASH, MO(LAYER_ID_MEDIA), KC_TAB, KC_Q, KC_W, KC_E, KC_R, KC_T,
        KC_PLUS, KC_MINUS, KC_Y, KC_U, KC_I, KC_O, KC_P, KC_BSLS, KC_LEFT_CTRL,
        KC_A, KC_S, KC_D, KC_F, KC_G, KC_AMPR, KC_EQUAL, KC_H, KC_J, KC_K, KC_L,
        KC_SCLN, KC_QUOTE, LM(LAYER_ID_SHIFT, MOD_LSFT), KC_Z, KC_X, KC_C, KC_V,
        KC_B, KC_N, KC_M, KC_COMMA, KC_DOT, KC_SLASH,
        LM(LAYER_ID_SHIFT, MOD_LSFT), KC_TRANSPARENT, KC_GRAVE, KC_DOWN, KC_UP,
        KC_ESCAPE, KC_TRANSPARENT, KC_TRANSPARENT, KC_RIGHT_ALT, KC_LEFT,
        KC_RIGHT, KC_AT, KC_TRANSPARENT, LM(LAYER_ID_SHIFT, MOD_LGUI), KC_BSPC,
        MO(LAYER_ID_FUNCTION), KC_TRANSPARENT, KC_ENTER, KC_SPACE),

    // shift
    [LAYER_ID_SHIFT] = LAYOUT_moonlander(
        KC_TRANSPARENT, KC_1, KC_2, KC_3, KC_4, KC_5, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_6, KC_7, KC_8, KC_9, KC_0, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_CIRC, KC_DLR, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_ASTR, KC_UNDS,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TILD, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT),

    // media / rgb controls
    [LAYER_ID_MEDIA] = LAYOUT_moonlander(
        KC_TRANSPARENT, RGB_SPI, RGB_SPD, RGB_MODE_FORWARD, TOGGLE_LAYER_COLOR,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_AUDIO_VOL_DOWN,
        KC_AUDIO_MUTE, KC_AUDIO_VOL_UP, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_MEDIA_PREV_TRACK, KC_NO, KC_MEDIA_PLAY_PAUSE, KC_MEDIA_NEXT_TRACK,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_NO, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_NO, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, TO(3), KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT),

    // qwerty
    [LAYER_ID_QWERTY] = LAYOUT_moonlander(
        KC_LGUI, KC_1, KC_2, KC_3,
        KC_4, KC_5, KC_TRANSPARENT, KC_TRANSPARENT, KC_6, KC_7, KC_8, KC_9,
        KC_0, TO(0), KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_SPACE, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT),

    // function keys
    [LAYER_ID_FUNCTION] = LAYOUT_moonlander(
        KC_TRANSPARENT, KC_F1, KC_F2, KC_F3, KC_F4, KC_F5, KC_F11, KC_F12,
        KC_F6, KC_F7, KC_F8, KC_F9, KC_F10, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT),
};
void keyboard_post_init_user(void) {
  debug_enable = true;
  rgb_matrix_enable();
}

#define COLOR_GROUP(name) name##_color_group, name##_color_group_size

#define CREATE_COLOR_GROUP(name, ...)                                          \
  const PROGMEM uint8_t name##_color_group[] = {__VA_ARGS__};                  \
  const uint8_t name##_color_group_size =                                      \
      (sizeof((uint8_t[]){__VA_ARGS__}) / sizeof(uint8_t));

CREATE_COLOR_GROUP(QWERTY_WASD, 7, 11, 12, 17);
CREATE_COLOR_GROUP(QWERTY_LAYER_EXIT, 36);
CREATE_COLOR_GROUP(QWERTY_SUPER, 0);
CREATE_COLOR_GROUP(SPACE, 32);
CREATE_COLOR_GROUP(SHIFT, 3, 39);
CREATE_COLOR_GROUP(MEDIA, 7, 12, 17, 22);
CREATE_COLOR_GROUP(VOLUME, 11, 16, 21);
CREATE_COLOR_GROUP(RGB_CONTROL, 5, 10, 15, 20);
CREATE_COLOR_GROUP(FUNCTION_KEYS, 5, 10, 15, 20, 25, 29, 41, 46, 51, 56, 61,
                   65);

void set_group_color(const uint8_t *color_group, uint8_t size, uint8_t r,
                     uint8_t g, uint8_t b) {
  for (int i = 0; i < size; i++) {
    uint8_t led_idx = pgm_read_byte(&color_group[i]);
    rgb_matrix_set_color(led_idx, r, g, b);
  }
}

bool rgb_matrix_indicators_user(void) {
  if (keyboard_config.disable_layer_led)
    return false;

  switch (get_highest_layer(layer_state | default_layer_state)) {
  case LAYER_ID_BASE:
    // keep animations on base
    break;

  case LAYER_ID_SHIFT: {
    set_group_color(COLOR_GROUP(SHIFT), RGB_BLUE);
    break;
  }

  case LAYER_ID_MEDIA:
    set_group_color(COLOR_GROUP(MEDIA), RGB_YELLOW);
    set_group_color(COLOR_GROUP(VOLUME), RGB_BLUE);
    set_group_color(COLOR_GROUP(RGB_CONTROL), RGB_PURPLE);
    break;

  case LAYER_ID_QWERTY:
    set_group_color(COLOR_GROUP(QWERTY_WASD), RGB_GREEN);
    set_group_color(COLOR_GROUP(SPACE), RGB_GREEN);
    set_group_color(COLOR_GROUP(QWERTY_LAYER_EXIT), RGB_RED);
    set_group_color(COLOR_GROUP(QWERTY_SUPER), RGB_RED);
    break;

  case LAYER_ID_FUNCTION:
    set_group_color(COLOR_GROUP(FUNCTION_KEYS), RGB_RED);
    break;
  }

  return true;
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  static uint8_t shift_count = 0;

  switch (keycode) {
  case LM(1, MOD_LSFT):
    // keep track of down shift keys
    record->event.pressed ? ++shift_count : --shift_count;
    // do not clear shift when another shift key is down
    if (!record->event.pressed && shift_count)
      return false;
    return true;

  case KC_1:
  case KC_2:
  case KC_3:
  case KC_4:
  case KC_5:
  case KC_6:
  case KC_7:
  case KC_8:
  case KC_9:
  case KC_0: {
    // behave normally outside shift layer
    if (IS_LAYER_OFF(LAYER_ID_SHIFT))
      return true;

    if (record->event.pressed) {
      if (get_mods() & MOD_LSFT)
        unregister_mods(MOD_LSFT);
      register_code((keycode));
    } else {
      // only put shift back if a shift key is down
      if (shift_count)
        register_mods(MOD_LSFT);
      unregister_code(keycode);
    }
    return false;
  }
  }

  return true;
}
