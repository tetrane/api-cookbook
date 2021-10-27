{% import "templates/bulma.tera" as bulma %}

# Following the dataflow

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.6.0"),
  bulma::preview_tag(),
]) }}

{{ bulma::related_examples(examples=[
  bulma::link(name="Use-after-Free vulnerabilities detection", url="../examples-book/analyze/vulnerability_detection/detect_use_after_free.html"),
  bulma::link(name="Searching for Buffer-Overflow vulnerabilities", url="../examples-book/analyze/vulnerability_detection/detect_buffer_overflow.html"),
  bulma::link(name="Searching for Use-of-Uninitialized-Memory vulnerabilities", url="../examples-book/analyze/vulnerability_detection/detect_use_of_uninitialized_memory.html"),
]) }}

{{ bulma::end_bulma() }}

## Finding out from where data comes

The below displays all processes and functions that some tainted buffer goes through:

```py
import reven2.preview.taint as tainting

tainter = tainting.Tainter(server.trace)

taint = tainter.simple_taint("rax", to_context=tr.context_before(), is_forward=False)

last_symbol = None
last_process = None
for access in taint.accesses().all():
    ctx_after = access.transition.context_after()
    new_process = ctx_after.ossi.process()
    new_symbol = ctx_after.ossi.location().symbol
    if new_symbol is None:
        if last_symbol is not None:
            print(f"{new_process}: ???")
        last_symbol = None
        last_process = new_process
        continue
    if (last_symbol is not None and last_process is not None
        and new_symbol == last_symbol
        and new_process.pid == last_process.pid
       ):
        continue

    last_symbol = new_symbol
    last_process = new_process

    print(f"{new_process}: {new_symbol}")

```


Sample output:

```
conhost.exe (2704): win32kfull!memcpy
conhost.exe (2704): msvcrt!memcpy
conhost.exe (2704): conhostv2!WriteCharsLegacy
conhost.exe (2704): conhostv2!WriteBuffer::Print
conhost.exe (2704): conhostv2!Microsoft::Console::VirtualTerminal::AdaptDispatch::Print
conhost.exe (2704): conhostv2!WriteChars
conhost.exe (2704): msvcrt!memcpy
conhost.exe (2704): conhostv2!WriteCharsLegacy
conhost.exe (2704): conhostv2!WriteBuffer::Print
conhost.exe (2704): conhostv2!Microsoft::Console::VirtualTerminal::AdaptDispatch::Print
conhost.exe (2704): conhostv2!WriteChars
conhost.exe (2704): msvcrt!memcpy
conhost.exe (2704): conhostv2!WriteCharsLegacy
conhost.exe (2704): conhostv2!WriteBuffer::Print
conhost.exe (2704): conhostv2!Microsoft::Console::VirtualTerminal::AdaptDispatch::Print
conhost.exe (2704): conhostv2!WriteChars
conhost.exe (2704): msvcrt!memcpy
conhost.exe (2704): conhostv2!WriteCharsLegacy
conhost.exe (2704): conhostv2!WriteBuffer::Print
conhost.exe (2704): conhostv2!Microsoft::Console::VirtualTerminal::AdaptDispatch::Print
conhost.exe (2704): conhostv2!WriteChars
conhost.exe (2704): msvcrt!memcpy
conhost.exe (2704): conhostv2!WriteCharsLegacy
conhost.exe (2704): conhostv2!WriteBuffer::Print
conhost.exe (2704): conhostv2!Microsoft::Console::VirtualTerminal::AdaptDispatch::Print
conhost.exe (2704): conhostv2!WriteChars
conhost.exe (2704): ???
chat_client.exe (2832): ntdll!memcpy
chat_client.exe (2832): chat_client!<alloc::vec::Vec<T> as alloc::vec::SpecExtend<T, I>>::from_iter
chat_client.exe (2832): ntdll!RtlpReAllocateHeapInternal
chat_client.exe (2832): ntdll!memcpy
chat_client.exe (2832): ntdll!RtlpReAllocateHeapInternal
chat_client.exe (2832): chat_client!<alloc::vec::Vec<T> as alloc::vec::SpecExtend<T, I>>::from_iter
chat_client.exe (2832): ntdll!RtlpAllocateHeapInternal
chat_client.exe (2832): chat_client!<alloc::vec::Vec<T> as alloc::vec::SpecExtend<T, I>>::from_iter
chat_client.exe (2832): msvcrt!memcpy
chat_client.exe (2832): netio!memcpy
chat_server.exe (648): netio!memcpy
chat_server.exe (648): ???
chat_server.exe (648): msvcrt!memcpy
chat_server.exe (648): chat_server!bytes::buf::buf_mut::BufMut::put
chat_server.exe (648): msvcrt!memcpy
chat_server.exe (648): chat_server!bytes::buf::buf_mut::BufMut::put
chat_server.exe (648): chat_server!<&'a str as bytes::buf::into_buf::IntoBuf>::into_buf
chat_server.exe (648): chat_server!<chat_server::Peer as futures::future::Future>::poll
chat_server.exe (648): chat_server!bytes::bytes::Inner::reserve
chat_server.exe (648): chat_server!<chat_server::Peer as futures::future::Future>::poll
chat_server.exe (648): chat_server!<futures::sync::mpsc::UnboundedReceiver<T> as futures::stream::Stream>::poll
chat_server.exe (648): chat_server!<futures::sync::mpsc::Receiver<T>>::next_message
chat_server.exe (648): chat_server!<futures::sync::mpsc::queue::Queue<T>>::pop
chat_server.exe (648): chat_server!<futures::sync::mpsc::Sender<T>>::queue_push_and_signal
chat_server.exe (648): chat_server!<chat_server::Peer as futures::future::Future>::poll
chat_server.exe (648): chat_server!<bytes::bytes::Bytes as core::clone::Clone>::clone
chat_server.exe (648): chat_server!<chat_server::Peer as futures::future::Future>::poll
chat_server.exe (648): chat_server!<bytes::bytes::BytesMut as bytes::buf::buf_mut::BufMut>::put_slice
chat_server.exe (648): chat_server!bytes::bytes::BytesMut::extend_from_slice
chat_server.exe (648): chat_server!bytes::bytes::Inner::reserve
chat_server.exe (648): chat_server!bytes::bytes::BytesMut::extend_from_slice
chat_server.exe (648): chat_server!<chat_server::Peer as futures::future::Future>::poll
chat_server.exe (648): chat_server!<bytes::bytes::BytesMut as bytes::buf::buf_mut::BufMut>::put_slice
chat_server.exe (648): chat_server!bytes::bytes::BytesMut::extend_from_slice
chat_server.exe (648): chat_server!bytes::bytes::Inner::reserve
chat_server.exe (648): chat_server!bytes::bytes::BytesMut::extend_from_slice
chat_server.exe (648): chat_server!<chat_server::Peer as futures::future::Future>::poll
chat_server.exe (648): chat_server!<bytes::bytes::BytesMut as bytes::buf::buf_mut::BufMut>::put_slice
chat_server.exe (648): msvcrt!memcpy
chat_server.exe (648): chat_server!<bytes::bytes::BytesMut as bytes::buf::buf_mut::BufMut>::put_slice
chat_server.exe (648): chat_server!bytes::bytes::BytesMut::extend_from_slice
chat_server.exe (648): chat_server!bytes::bytes::Inner::reserve
chat_server.exe (648): chat_server!bytes::bytes::BytesMut::extend_from_slice
chat_server.exe (648): chat_server!<chat_server::Peer as futures::future::Future>::poll
chat_server.exe (648): chat_server!<bytes::bytes::BytesMut as core::clone::Clone>::clone
chat_server.exe (648): msvcrt!memcpy
chat_server.exe (648): chat_server!<bytes::bytes::BytesMut as core::clone::Clone>::clone
chat_server.exe (648): chat_server!<chat_server::Peer as futures::future::Future>::poll
chat_server.exe (648): chat_server!<chat_server::Lines as futures::stream::Stream>::poll
chat_server.exe (648): chat_server!bytes::bytes::BytesMut::split_off
chat_server.exe (648): chat_server!bytes::bytes::Inner::set_start
chat_server.exe (648): chat_server!bytes::bytes::BytesMut::split_off
chat_server.exe (648): chat_server!<chat_server::Lines as futures::stream::Stream>::poll
chat_server.exe (648): chat_server!bytes::bytes::BytesMut::split_to
chat_server.exe (648): chat_server!bytes::bytes::Inner::shallow_clone_sync
chat_server.exe (648): chat_server!bytes::bytes::BytesMut::split_to
chat_server.exe (648): chat_server!<chat_server::Lines as futures::stream::Stream>::poll
chat_server.exe (648): chat_server!<tokio_tcp::stream::TcpStream as tokio_io::async_read::AsyncRead>::read_buf
chat_server.exe (648): chat_server!mio::sys::windows::tcp::TcpStream::readv
chat_server.exe (648): chat_server!<&'a std::net::tcp::TcpStream as std::io::Read>::read
chat_server.exe (648): ws2_32!recv
chat_server.exe (648): mswsock!WSPRecv
chat_server.exe (648): ntoskrnl!IopXxxControlFile
chat_server.exe (648): ???
chat_server.exe (648): ntoskrnl!IopXxxControlFile
chat_server.exe (648): ntoskrnl!NtDeviceIoControlFile
chat_server.exe (648): ntoskrnl!KiSystemCall64
chat_server.exe (648): mswsock!WSPRecv
chat_server.exe (648): ws2_32!recv
chat_server.exe (648): chat_server!mio::sys::windows::tcp::TcpStream::readv
chat_client.exe (2816): ???
chat_client.exe (2816): netio!RtlCopyMdlToBuffer
chat_client.exe (2816): ???
chat_client.exe (2816): tcpip!TcpIndicateData
chat_client.exe (2816): ndis!NdisAdvanceNetBufferDataStart
chat_client.exe (2816): tcpip!IppPrevalidateLoopbackReceive
chat_client.exe (2816): tcpip!IpNlpFastContinueSendDatagram
chat_client.exe (2816): tcpip!IppSendDatagramsCommon
chat_client.exe (2816): tcpip!IppPreparePacketChecksum
chat_client.exe (2816): tcpip!IppSendDatagramsCommon
chat_client.exe (2816): tcpip!TcpTcbSend
chat_client.exe (2816): netio!NetioExtendNetBuffer
chat_client.exe (2816): tcpip!TcpSegmentTcbSend
chat_client.exe (2816): tcpip!TcpBeginTcbSend
chat_client.exe (2816): netio!NetioAllocateAndReferenceNetBufferListNetBufferMdlAndData
chat_client.exe (2816): ndis!NdisAllocateNetBufferList
chat_client.exe (2816): netio!NetioAllocateAndReferenceNetBufferListNetBufferMdlAndData
chat_client.exe (2816): tcpip!TcpBeginTcbSend
chat_client.exe (2816): tcpip!TcpTcbSend
chat_client.exe (2816): tcpip!TcpEnqueueTcbSend
chat_client.exe (2816): ???
chat_client.exe (2816): chat_client!<std::net::tcp::TcpStream as miow::net::TcpStreamExt>::write_overlapped
chat_client.exe (2816): chat_client!mio::sys::windows::tcp::StreamImp::schedule_write
chat_client.exe (2816): chat_client!mio::poll::SetReadiness::set_readiness
chat_client.exe (2816): chat_client!mio::sys::windows::tcp::StreamImp::schedule_write
chat_client.exe (2816): chat_client!mio::sys::windows::tcp::TcpStream::writev
chat_client.exe (2816): chat_client!<iovec::IoVec as core::ops::deref::Deref>::deref
chat_client.exe (2816): chat_client!mio::sys::windows::tcp::TcpStream::writev
chat_client.exe (2816): chat_client!mio::sys::windows::selector::ReadyBinding::get_buffer
chat_client.exe (2816): chat_client!<mio::net::tcp::TcpStream as std::io::Write>::write
chat_client.exe (2816): chat_client!iovec::IoVec::from_bytes
chat_client.exe (2816): chat_client!<mio::net::tcp::TcpStream as std::io::Write>::write
chat_client.exe (2816): chat_client!<tokio_reactor::poll_evented::PollEvented<E> as std::io::Write>::write
chat_client.exe (2816): chat_client!<tokio_reactor::poll_evented::PollEvented<E>>::poll_write_ready
chat_client.exe (2816): chat_client!<tokio_reactor::poll_evented::PollEvented<E> as std::io::Write>::write
chat_client.exe (2816): chat_client!_ZN99_$LT$tokio_io.._tokio_codec..framed_write..FramedWrite2$LT$T$GT$$u20$as$u20$futures..sink..Sink$GT$13poll_complete17h99e4d
chat_client.exe (2816): chat_client!bytes::buf::buf_mut::BufMut::put
chat_client.exe (2816): chat_client!<&'a str as bytes::buf::into_buf::IntoBuf>::into_buf
chat_client.exe (2816): chat_client!_ZN99_$LT$tokio_io.._tokio_codec..framed_write..FramedWrite2$LT$T$GT$$u20$as$u20$futures..sink..Sink$GT$10start_send17h590abca8
chat_client.exe (2816): chat_client!<futures::stream::split::SplitSink<S> as futures::sink::Sink>::start_send
chat_client.exe (2816): chat_client!<futures::stream::forward::Forward<T, U>>::try_start_send
chat_client.exe (2816): chat_client!<futures::stream::forward::Forward<T, U> as futures::future::Future>::poll
chat_client.exe (2816): chat_client!<futures::stream::map_err::MapErr<S, F> as futures::stream::Stream>::poll
chat_client.exe (2816): chat_client!<futures::sync::mpsc::Receiver<T> as futures::stream::Stream>::poll
chat_client.exe (2816): chat_client!<futures::sync::mpsc::Receiver<T>>::next_message
chat_client.exe (2816): chat_client!<futures::sync::mpsc::queue::Queue<T>>::pop
chat_client.exe (2816): chat_client!<futures::sync::mpsc::Sender<T>>::do_send
chat_client.exe (2816): chat_client!<futures::sink::send::Send<S> as futures::future::Future>::poll
chat_client.exe (2816): chat_client!futures::future::Future::wait
chat_client.exe (2816): chat_client!chat_client::read_stdin
chat_client.exe (2816): chat_client!<std::io::stdio::Stdin as std::io::Read>::read
chat_client.exe (2816): chat_client!<std::io::buffered::BufReader<R> as std::io::Read>::read
chat_client.exe (2816): chat_client!<std::io::buffered::BufReader<R> as std::io::BufRead>::fill_buf
chat_client.exe (2816): chat_client!std::sys::windows::stdio::Stdin::read
chat_client.exe (2816): chat_client!<std::io::cursor::Cursor<T> as std::io::Read>::read
chat_client.exe (2816): chat_client!std::sys::windows::stdio::Stdin::read
chat_client.exe (2816): ntdll!RtlpFreeHeap
chat_client.exe (2816): chat_client!std::sys::windows::stdio::Stdin::read
chat_client.exe (2816): chat_client!alloc::string::String::from_utf16
chat_client.exe (2816): chat_client!alloc::string::String::push
chat_client.exe (2816): ntdll!RtlpReAllocateHeapInternal
chat_client.exe (2816): chat_client!alloc::string::String::push
chat_client.exe (2816): ntdll!RtlpReAllocateHeapInternal
chat_client.exe (2816): chat_client!alloc::string::String::push
chat_client.exe (2816): ntdll!RtlpReAllocateHeapInternal
chat_client.exe (2816): chat_client!alloc::string::String::push
chat_client.exe (2816): ntdll!RtlpAllocateHeapInternal
chat_client.exe (2816): chat_client!alloc::string::String::from_utf16
chat_client.exe (2816): kernelbase!StrRetToStrW
```
