using AVFoundation;
using MediaPlayer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MacControlCenter.Platforms.MacCatalyst
{
    public class AudioService : IAudioService
    {
        AVQueuePlayer player;
        private bool isPlaying;
        private NSUrl podcastUrl;

        public AudioService()
        {
            this.podcastUrl = new NSUrl("https://chtbl.com/track/84EGD/aphid.fireside.fm/d/1437767933/c0a23311-553b-4a26-9aff-416a20d5822b/ac96179d-2352-44d0-9edb-98b7c46fdc6a.mp3");
            player = new AVQueuePlayer();
            this.SetupRemoteControls();
        }

        public void Pause()
        {
            throw new NotImplementedException();
        }

        public void Play()
        {
            if (isPlaying)
            {
                this.Pause();
            }
            var playerItem = new AVPlayerItem(this.podcastUrl);
            player.InsertItem(playerItem, null);
            player.Play();
            SetNowPlayingMetadata();
            isPlaying = true;
        }

        private void SetupRemoteControls()
        {
            var commandCenter = MPRemoteCommandCenter.Shared;

            commandCenter.PlayCommand.AddTarget((playEvent) => playHandler(playEvent));
            commandCenter.PauseCommand.AddTarget((pauseEvent) => pauseHandler(pauseEvent));
        }

        private MPRemoteCommandHandlerStatus playHandler(MPRemoteCommandEvent playEvent)
        {
            if (player.Rate == 0.0)
            {
                player.Play();
                UpdateIsPlayingOnControlCenter();
                return MPRemoteCommandHandlerStatus.Success;
            }

            return MPRemoteCommandHandlerStatus.CommandFailed;
        }

        private MPRemoteCommandHandlerStatus pauseHandler(MPRemoteCommandEvent pauseEvent)
        {
            if (player.Rate == 0.0)
            {
                player.Pause();
                isPlaying = false;
                UpdateIsPlayingOnControlCenter();
                return MPRemoteCommandHandlerStatus.Success;
            }

            return MPRemoteCommandHandlerStatus.CommandFailed;
        }

        private void SetNowPlayingMetadata()
        {
            var center = MPNowPlayingInfoCenter.DefaultCenter;
            center.NowPlaying = new MPNowPlayingInfo()
            {
                Title = "maui",
                Artist = "dotnet",
                AssetUrl = this.podcastUrl

            };
        }

        private void UpdateIsPlayingOnControlCenter()
        {
            //MPNowPlayingInfoCenter.DefaultCenter.NowPlaying.
        }


    }
}
