// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VoiceController)
final voiceControllerProvider = VoiceControllerProvider._();

final class VoiceControllerProvider
    extends $NotifierProvider<VoiceController, VoiceState> {
  VoiceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voiceControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voiceControllerHash();

  @$internal
  @override
  VoiceController create() => VoiceController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoiceState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoiceState>(value),
    );
  }
}

String _$voiceControllerHash() => r'c653e19f7687594fd0145162fff382564d9a6a3b';

abstract class _$VoiceController extends $Notifier<VoiceState> {
  VoiceState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VoiceState, VoiceState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VoiceState, VoiceState>,
              VoiceState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
