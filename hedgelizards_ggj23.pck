GDPC                                                                               <   res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex       �      &�y���ڞu;>��.p   res://icon.png.import    	      �      ��fe��6�B��^ U�   res://project.binary�      `      ���7�o����'q�   res://scenes/Player.tscn�      �      �!�s�ZQ:>a���OGb   res://scenes/VersionTag.tscn�      �       ��JO@��r�~]o�z�   res://scenes/World.tscn �      �      7m�"y:WF��,�\    res://scripts/player.gd.remap   �      )       �'���u�4�SX�   res://scripts/player.gdc`      N      e��X�]�0��]��    res://scripts/version.gd.remap  �      *       �/��j(\
c_   res://scripts/version.gdc   �      �      .�-�G5K5w�R�   res://version.tres  �             <L�%���qG��:�pGDST@   @            �  WEBPRIFF�  WEBPVP8L�  /?����m��������_"�0@��^�"�v��s�}� �W��<f��Yn#I������wO���M`ҋ���N��m:�
��{-�4b7DԧQ��A �B�P��*B��v��
Q�-����^R�D���!(����T�B�*�*���%E["��M�\͆B�@�U$R�l)���{�B���@%P����g*Ųs�TP��a��dD
�6�9�UR�s����1ʲ�X�!�Ha�ߛ�$��N����i�a΁}c Rm��1��Q�c���fdB�5������J˚>>���s1��}����>����Y��?�TEDױ���s���\�T���4D����]ׯ�(aD��Ѓ!�a'\�G(��$+c$�|'�>����/B��c�v��_oH���9(l�fH������8��vV�m�^�|�m۶m�����q���k2�='���:_>��������á����-wӷU�x�˹�fa���������ӭ�M���SƷ7������|��v��v���m�d���ŝ,��L��Y��ݛ�X�\֣� ���{�#3���
�6������t`�
��t�4O��ǎ%����u[B�����O̲H��o߾��$���f���� �H��\��� �kߡ}�~$�f���N\�[�=�'��Nr:a���si����(9Lΰ���=����q-��W��LL%ɩ	��V����R)�=jM����d`�ԙHT�c���'ʦI��DD�R��C׶�&����|t Sw�|WV&�^��bt5WW,v�Ş�qf���+���Jf�t�s�-BG�t�"&�Ɗ����׵�Ջ�KL�2)gD� ���� NEƋ�R;k?.{L�$�y���{'��`��ٟ��i��{z�5��i������c���Z^�
h�+U�mC��b��J��uE�c�����h��}{�����i�'�9r�����ߨ򅿿��hR�Mt�Rb���C�DI��iZ�6i"�DN�3���J�zڷ#oL����Q �W��D@!'��;�� D*�K�J�%"�0�����pZԉO�A��b%�l�#��$A�W�A�*^i�$�%a��rvU5A�ɺ�'a<��&�DQ��r6ƈZC_B)�N�N(�����(z��y�&H�ض^��1Z4*,RQjԫ׶c����yq��4���?�R�����0�6f2Il9j��ZK�4���է�0؍è�ӈ�Uq�3�=[vQ�d$���±eϘA�����R�^��=%:�G�v��)�ǖ/��RcO���z .�ߺ��S&Q����o,X�`�����|��s�<3Z��lns'���vw���Y��>V����G�nuk:��5�U.�v��|����W���Z���4�@U3U�������|�r�?;�
         [remap]

importer="texture"
type="StreamTexture"
path="res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://icon.png"
dest_files=[ "res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
              [gd_scene load_steps=4 format=2]

[ext_resource path="res://scripts/player.gd" type="Script" id=1]
[ext_resource path="res://icon.png" type="Texture" id=2]

[sub_resource type="RectangleShape2D" id=1]
extents = Vector2( 24, 24 )

[node name="Player" type="KinematicBody2D"]
position = Vector2( 200, 300 )
script = ExtResource( 1 )

[node name="Icon" type="Sprite" parent="."]
texture = ExtResource( 2 )

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
shape = SubResource( 1 )
 [gd_scene load_steps=2 format=2]

[ext_resource path="res://scripts/version.gd" type="Script" id=1]

[node name="VersionTag" type="Label"]
margin_bottom = 14.0
text = "version"
valign = 2
script = ExtResource( 1 )
          [gd_scene load_steps=3 format=2]

[ext_resource path="res://scenes/Player.tscn" type="PackedScene" id=1]
[ext_resource path="res://scenes/VersionTag.tscn" type="PackedScene" id=2]

[node name="World" type="Node2D"]

[node name="CanvasLayer" type="CanvasLayer" parent="."]

[node name="VersionTag" parent="CanvasLayer" instance=ExtResource( 2 )]
margin_left = 5.0
margin_top = 5.0
margin_right = 52.0
margin_bottom = 19.0

[node name="Player" parent="." instance=ExtResource( 1 )]
GDSC            a      ������������τ�   ����Ҷ��   �����϶�   ���������������Ŷ���   ����׶��   ��ƶ   ����¶��   ����������������Ҷ��   ��ڶ   ���������Ҷ�   �������������Ӷ�            right         left      down      up                           
                           	      
         "      7      K      M      X      _      3YYY8;�  YYY0�  PQV�  -YY0�  P�  QV�  ;�  �  P�  �  P�  T�  P�  QQ�  P�  T�  P�  QQR�  �  P�  T�  P�  QQ�  P�  T�  P�  QQ�  Q�  ;�  �  T�	  PQ�  �  T�
  P�  QY`  GDSC            ;      ����ڶ��   �����������Ӷ���   �����϶�   ���Ӷ���   ���Ӷ���   ����   ���ض���   ���򶶶�   ���¶���   �������Ӷ���   ����Ӷ��   �������Ӷ���   ׶��      res://version.tres        ?                         	      
                  $   	   ,   
   2      8      9      3YYY:�  YY0�  PQV�  ;�  �  T�  PQ�  �  T�  P�  R�  T�  Q�  �  �  T�	  PQ�  �  T�
  PQ�  �  T�  �  YY`        v0.1.26
        [remap]

path="res://scripts/player.gdc"
       [remap]

path="res://scripts/version.gdc"
      ECFG      application/config/name         23ggj      application/run/main_scene          res://scenes/World.tscn    debug/settings/fps/force_fps      �      debug/gdscript/warnings/enable          +   display/window/energy_saving/keep_screen_on          +   gui/common/drop_mouse_on_gui_input_disabled            input/up�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device            alt           shift             control           meta          command           pressed           scancode          physical_scancode      W      unicode           echo          script            InputEventKey         resource_local_to_scene           resource_name             device            alt           shift             control           meta          command           pressed           scancode          physical_scancode           unicode           echo          script      
   input/down�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device            alt           shift             control           meta          command           pressed           scancode          physical_scancode      S      unicode           echo          script            InputEventKey         resource_local_to_scene           resource_name             device            alt           shift             control           meta          command           pressed           scancode          physical_scancode           unicode           echo          script      
   input/left�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device            alt           shift             control           meta          command           pressed           scancode          physical_scancode      A      unicode           echo          script            InputEventKey         resource_local_to_scene           resource_name             device            alt           shift             control           meta          command           pressed           scancode          physical_scancode           unicode           echo          script         input/right�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device            alt           shift             control           meta          command           pressed           scancode          physical_scancode      D      unicode           echo          script            InputEventKey         resource_local_to_scene           resource_name             device            alt           shift             control           meta          command           pressed           scancode          physical_scancode           unicode           echo          script      +   logging/file_logging/enable_file_logging.pc          )   physics/common/enable_pause_aware_picking         $   rendering/quality/driver/driver_name         GLES2   7   rendering/quality/intended_usage/framebuffer_allocation          >   rendering/quality/intended_usage/framebuffer_allocation.mobile         %   rendering/vram_compression/import_etc         &   rendering/vram_compression/import_etc2          