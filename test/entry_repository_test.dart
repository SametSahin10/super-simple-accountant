import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_simple_accountant/data_sources/entry_local_data_source.dart';
import 'package:super_simple_accountant/data_sources/entry_remote_data_source.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/repositories/entry_repository.dart';
import 'package:super_simple_accountant/services/connectivity_service.dart';

class MockEntryLocalDataSource extends Mock implements EntryLocalDataSource {}

class MockEntryRemoteDataSource extends Mock implements EntryRemoteDataSource {}

class MockConnectivityService extends Mock implements ConnectivityService {}

class FakeEntry extends Fake implements Entry {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeEntry());
  });

  late EntryRepository repository;
  late MockEntryLocalDataSource mockLocalDataSource;
  late MockEntryRemoteDataSource mockRemoteDataSource;
  late MockConnectivityService mockConnectivityService;

  setUp(() {
    mockLocalDataSource = MockEntryLocalDataSource();
    mockRemoteDataSource = MockEntryRemoteDataSource();
    mockConnectivityService = MockConnectivityService();

    repository = EntryRepository(
      entryRemoteDataSource: mockRemoteDataSource,
      entryLocalDataSource: mockLocalDataSource,
      connectivityService: mockConnectivityService,
    );
  });

  group('saveEntry', () {
    final testEntry = Entry(
      id: '1',
      amount: 100,
      description: 'Test',
      createdAt: DateTime.now(),
      userId: 'user1',
      isSynced: true,
    );

    test('saves entry locally when offline', () async {
      when(() {
        return mockConnectivityService.hasInternetConnection();
      }).thenAnswer((_) async => false);

      when(() {
        return mockLocalDataSource.saveEntry(
          testEntry.copyWith(isSynced: false),
        );
      }).thenAnswer((_) async => true);

      await repository.saveEntry(entry: testEntry, isPlusUser: true);

      verify(() => mockLocalDataSource.saveEntry(any())).called(1);
      verifyNever(() => mockRemoteDataSource.createEntry(any()));
    });

    test(
      'saves entry locally and marks as synced when online and plus user',
      () async {
        when(() {
          return mockConnectivityService.hasInternetConnection();
        }).thenAnswer((_) async => true);

        when(() {
          return mockLocalDataSource.saveEntry(
            testEntry.copyWith(isSynced: false),
          );
        }).thenAnswer((_) async => true);

        when(() {
          return mockRemoteDataSource.createEntry(testEntry);
        }).thenAnswer((_) async => '1');

        when(() {
          return mockLocalDataSource.markEntrySynced(testEntry);
        }).thenAnswer((_) async => true);

        await repository.saveEntry(entry: testEntry, isPlusUser: true);

        verify(() {
          return mockLocalDataSource.saveEntry(
            testEntry.copyWith(isSynced: false),
          );
        }).called(1);

        verify(() => mockRemoteDataSource.createEntry(testEntry)).called(1);
        verify(() => mockLocalDataSource.markEntrySynced(testEntry)).called(1);
      },
    );
  });

  group('deleteEntry', () {
    final testEntry = Entry(
      id: '1',
      amount: 100,
      description: 'Test',
      createdAt: DateTime.now(),
      userId: 'user1',
      isSynced: true,
    );

    test('deletes entry only locally when offline', () async {
      when(() {
        return mockConnectivityService.hasInternetConnection();
      }).thenAnswer((_) async => false);

      when(() {
        return mockLocalDataSource.deleteEntry(testEntry);
      }).thenAnswer((_) async => true);

      await repository.deleteEntry(entry: testEntry, isPlusUser: true);

      verify(() => mockLocalDataSource.deleteEntry(testEntry)).called(1);
      verifyNever(() => mockRemoteDataSource.deleteEntry(any()));
    });

    test(
      'deletes entry both locally and remotely when online and plus user',
      () async {
        when(() {
          return mockConnectivityService.hasInternetConnection();
        }).thenAnswer((_) async => true);

        when(() {
          return mockLocalDataSource.deleteEntry(testEntry);
        }).thenAnswer((_) async => true);

        when(() {
          return mockRemoteDataSource.deleteEntry(testEntry);
        }).thenAnswer((_) async => true);

        await repository.deleteEntry(entry: testEntry, isPlusUser: true);

        verify(() => mockLocalDataSource.deleteEntry(testEntry)).called(1);
        verify(() => mockRemoteDataSource.deleteEntry(testEntry)).called(1);
      },
    );
  });

  group('getEntries', () {
    final testEntries = [
      Entry(
        id: '1',
        amount: 100,
        description: 'Test 1',
        createdAt: DateTime.now(),
        userId: 'user1',
        isSynced: true,
      ),
      Entry(
        id: '2',
        amount: 200,
        description: 'Test 2',
        createdAt: DateTime.now(),
        userId: 'user1',
        isSynced: true,
      ),
    ];

    test('returns local entries when offline', () async {
      when(() {
        return mockConnectivityService.hasInternetConnection();
      }).thenAnswer((_) async => false);

      when(() {
        return mockLocalDataSource.getEntries();
      }).thenAnswer((_) async => testEntries);

      final result = await repository.getEntries(
        userId: 'user1',
        isPlusUser: true,
      );

      expect(result, equals(testEntries));

      verify(() => mockLocalDataSource.getEntries()).called(1);

      verifyNever(() {
        return mockRemoteDataSource.getAllEntries(
          userId: any(named: 'userId'),
        );
      });
    });

    test(
      'returns remote entries and syncs locally when online and plus user',
      () async {
        when(() {
          return mockConnectivityService.hasInternetConnection();
        }).thenAnswer((_) async => true);

        when(() {
          return mockRemoteDataSource.getAllEntries(userId: 'user1');
        }).thenAnswer((_) async => testEntries);

        when(() {
          return mockLocalDataSource.syncWithRemote(testEntries);
        }).thenAnswer((_) async => true);

        final result = await repository.getEntries(
          userId: 'user1',
          isPlusUser: true,
        );

        expect(result, equals(testEntries));

        verify(() {
          return mockRemoteDataSource.getAllEntries(
            userId: any(named: 'userId'),
          );
        }).called(1);

        verify(() => mockLocalDataSource.syncWithRemote(testEntries)).called(1);
      },
    );

    test('falls back to local entries when remote fetch fails', () async {
      when(() {
        return mockConnectivityService.hasInternetConnection();
      }).thenAnswer((_) async => true);

      when(() {
        return mockRemoteDataSource.getAllEntries(userId: 'user1');
      }).thenThrow(Exception('Network error'));

      when(() {
        return mockLocalDataSource.getEntries();
      }).thenAnswer((_) async => testEntries);

      final result = await repository.getEntries(
        userId: "user1",
        isPlusUser: true,
      );

      expect(result, equals(testEntries));

      verify(() {
        return mockRemoteDataSource.getAllEntries(userId: any(named: 'userId'));
      }).called(1);

      verify(() => mockLocalDataSource.getEntries()).called(1);
    });
  });
}
